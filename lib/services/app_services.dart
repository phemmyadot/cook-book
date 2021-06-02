import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipiebook/models/user.dart';
import 'package:recipiebook/models/http_exception.dart';

class AppServices {
  final CollectionReference<Map<String, dynamic>> _userCollectionReference =
      FirebaseFirestore.instance.collection("user");
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> registerUserProfile(String userName, String userId) async {
    try {
      final token = '';
      await _firebaseAuth.signInAnonymously();
      _userCollectionReference.doc(userId).set(
            UserModel(
              userName: userName,
              token: token,
              createdBy: userName,
              createdOn: DateTime.now(),
              modifiedBy: userName,
              modifiedOn: DateTime.now(),
            ).toJson(),
          );
    } catch (e) {
      throw HttpException(e.message);
    }
  }
}
