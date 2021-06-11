import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:metadata_extract/metadata_extract.dart';
import 'package:recipiebook/models/favorite.dart';
import 'package:recipiebook/models/keyword.dart';
import 'package:recipiebook/models/recipe.dart';
import 'package:recipiebook/models/user.dart';
import 'package:recipiebook/models/http_exception.dart';
import 'package:recipiebook/utils/string_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class AppServices {
  final CollectionReference<Map<String, dynamic>> _userCollectionReference =
      FirebaseFirestore.instance.collection("user");
  final CollectionReference<Map<String, dynamic>> _recipeCollectionReference =
      FirebaseFirestore.instance.collection("recipe");
  final CollectionReference<Map<String, dynamic>> _keywordCollectionReference =
      FirebaseFirestore.instance.collection("keyword");
  final CollectionReference<Map<String, dynamic>> _favoriteCollectionReference =
      FirebaseFirestore.instance.collection("favorite");
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<String> _defaultPaths = RBStringUtils.defaultPaths;

  Future<void> authenticate() async {
    await _firebaseAuth.signInAnonymously();
  }

  Future<List<UserModel>> getAllUsers() async {
    return _userCollectionReference
        .get()
        .then((u) => u.docs.map((e) => UserModel.fromData(e)).toList());
  }

  Future<void> registerUserProfile(
      String userName, String userId, String token) async {
    try {
      _userCollectionReference.doc(userId).set(
            UserModel(
              userName: userName,
              token: token,
              createdBy: userId,
              createdOn: DateTime.now(),
              modifiedBy: userId,
              modifiedOn: DateTime.now(),
            ).toJson(),
          );
    } catch (e) {
      throw HttpException(e.message);
    }
  }

  Future<void> updateToken(String token, String userId) async {
    try {
      if (userId != null)
        _userCollectionReference.doc(userId).update({'token': token});
    } catch (e) {
      throw HttpException(e.message);
    }
  }

  Future<void> addRecipe(String title, String link, String creator,
      String userId, List<String> keywords, List<UserModel> users) async {
    try {
      final recipeId = Uuid().v1();
      final image = await getImage(link);
      final hasNetworkImage = image != null || !image.contains('youtube');
      _recipeCollectionReference.doc(recipeId).set(
            Recipe(
              title: title,
              imageLink: hasNetworkImage ? image : getDefaultImage(keywords),
              link: link,
              creatorName: creator,
              hasNetworkImage: hasNetworkImage,
              createdBy: userId,
              createdOn: DateTime.now(),
              modifiedBy: userId,
              modifiedOn: DateTime.now(),
            ).toJson(),
          );
      for (int i = 0; i < keywords.length; i++) {
        final keywordId = Uuid().v1();
        _keywordCollectionReference.doc(keywordId).set(Keyword(
              recipeId: recipeId,
              keyword: keywords[i],
              createdBy: userId,
              createdOn: DateTime.now(),
              modifiedBy: userId,
              modifiedOn: DateTime.now(),
            ).toJson());
      }
      sendPushMessage(title, users);
    } catch (e) {
      throw HttpException(e?.message);
    }
  }

  String constructFCMPayload(String token, String title) {
    return jsonEncode({
      'token': token,
      'notification': {
        'title': 'A new recpe has been added!',
        'body': title,
      },
    });
  }

  Future<void> sendPushMessage(String title, List<UserModel> users) async {
    for (int i = 0; i < users.length; i++) {
      if (users[i].token.isNotEmpty) {
        try {
          await http
              .post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAAbXVdpnc:APA91bGlJzm7IzKZ2QrH2quE72ML7RlWxi9TsweyI_1t7-cX2C3BUYmVRt5kS1sy-kOsv_tqDnaBpXw6q8IsLhbbnNi6WlGWn3tgIyryk4bbk2IsX4poEdri7R4sQjXtlhxLLB7VPnuJ',
            },
            body: jsonEncode(
              <String, dynamic>{
                'notification': <String, dynamic>{
                  'body': title,
                  'title': 'A new recipe has been added!',
                },
                'priority': 'high',
                'data': <String, dynamic>{
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'id': '1',
                  'status': 'done'
                },
                'to': users[i].token,
              },
            ),
          )
              .whenComplete(() {
            print('sendOrderCollected(): message sent to ${users[i].userName}');
          });
        } catch (e) {
          print(e);
        }
      }
    }
  }

  String getDefaultImage(List<String> keywords) {
    if (_defaultPaths.any((r) => keywords.any((f) => r.contains(f)))) {
      final path =
          _defaultPaths.firstWhere((r) => keywords.any((f) => r.contains(f)));
      return 'assets/images/$path';
    } else {
      return RBStringUtils.defaultImage;
    }
  }

  Future<void> addRecipeToFavorite(String recipeId, String userId) async {
    try {
      final favoriteId = Uuid().v1();
      _favoriteCollectionReference.doc(favoriteId).set(
            Favorite(
              recipeId: recipeId,
              createdBy: userId,
              createdOn: DateTime.now(),
              modifiedBy: userId,
              modifiedOn: DateTime.now(),
            ).toJson(),
          );
    } catch (e) {
      throw HttpException(e.message);
    }
  }

  Future<void> removeRecipeFromFavorite(String favoriteId) async {
    try {
      _favoriteCollectionReference.doc(favoriteId).delete();
    } catch (e) {
      throw HttpException(e.message);
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    try {
      _recipeCollectionReference.doc(recipeId).delete();
    } catch (e) {
      throw HttpException(e.message);
    }
  }

  Stream<List<RecipeKeyword>> getRecipes() {
    Stream<List<RecipeKeyword>> _combineStream;
    try {
      _combineStream = _recipeCollectionReference.snapshots().map((convert) {
        return convert.docs.map((f) {
          Stream<Recipe> recipe =
              Stream.value(f).map<Recipe>((doc) => Recipe.fromData(doc));

          Stream<List<Keyword>> keywords = _keywordCollectionReference
              .where('recipeId', isEqualTo: f.id)
              .snapshots()
              .map<List<Keyword>>(
                  (list) => list.docs.map((e) => Keyword.fromData(e)).toList());

          return Rx.combineLatest2(
              recipe,
              keywords,
              (Recipe recipe, List<Keyword> keywords) =>
                  RecipeKeyword(keywords: keywords, recipe: recipe));
        });
      }).switchMap((observables) {
        return observables.length > 0
            ? Rx.combineLatestList(observables)
            : Stream.value([]);
      });
      return _combineStream;
    } catch (e) {
      throw HttpException(e.message);
    }
  }

  Stream<List<Favorite>> getFavorites() {
    try {
      var devotionals = _favoriteCollectionReference.snapshots();
      return devotionals
          .map((e) => e.docs.map((e) => Favorite.fromData(e)).toList());
    } catch (e) {
      throw HttpException(e.message);
    }
  }

  Future<String> getImage(String url) async {
    var client = http.Client();
    var urlSplit = url.split('//');
    final path = urlSplit.length > 1 ? urlSplit[1] : urlSplit[0];
    int idx = path.indexOf("/");
    List paths = idx < 0
        ? [urlSplit[1], '/']
        : [path.substring(0, idx).trim(), '/${path.substring(idx + 1).trim()}'];

    http.Response response = await client.get(Uri.https(paths[0], paths[1]));

    var document = responseToDocument(response);
    if (document == null && urlSplit[1].contains('youtube'))
      return 'assets/images/youtube.png';
    if (document == null) return null;
    var data = MetadataParser.parse(document);
    if (data == null)
      return null;
    else
      return Future.value(data.image);
  }
}
