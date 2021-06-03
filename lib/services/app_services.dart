import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipiebook/models/favorite.dart';
import 'package:recipiebook/models/keyword.dart';
import 'package:recipiebook/models/recipe.dart';
import 'package:recipiebook/models/user.dart';
import 'package:recipiebook/models/http_exception.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

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

  Future<void> authenticate() async {
    await _firebaseAuth.signInAnonymously();
  }

  Future<void> registerUserProfile(String userName, String userId) async {
    try {
      final token = ''; //TODO: token from firebase messaging

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

  Future<void> addRecipe(
    String title,
    String imageLink,
    String link,
    String creator,
    String userId,
    List<String> keywords,
    bool hasNetworkImage,
  ) async {
    try {
      final recipeId = Uuid().v1();
      _recipeCollectionReference.doc(recipeId).set(
            Recipe(
              title: title,
              imageLink: imageLink,
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
    } catch (e) {
      throw HttpException(e.message);
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

  Future<UploadTask> uploadFile(PickedFile file, String title) async {
    UploadTask uploadTask;
    final extension = p.extension(file.path);
    Reference ref = FirebaseStorage.instance.ref().child('/$title$extension');

    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    uploadTask = ref.putFile(File(file.path), metadata);

    return Future.value(uploadTask);
  }
}
