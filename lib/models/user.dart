import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String id;
  final String userName;
  final String token;
  final String createdBy;
  final DateTime createdOn;
  final String modifiedBy;
  final DateTime modifiedOn;

  const UserModel({
    this.id,
    @required this.userName,
    @required this.token,
    @required this.createdBy,
    @required this.createdOn,
    @required this.modifiedBy,
    @required this.modifiedOn,
  });

  UserModel.fromData(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        userName = snapshot.data()['userName'],
        token = snapshot.data()['token'],
        createdBy = snapshot.data()['createdBy'],
        createdOn = snapshot.data()['createdOn'].toDate(),
        modifiedBy = snapshot.data()['modifiedBy'],
        modifiedOn = snapshot.data()['modifiedOn'].toDate();

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'token': token,
      'createdBy': createdBy,
      'createdOn': createdOn,
      'modifiedBy': modifiedBy,
      'modifiedOn': modifiedOn,
    };
  }
}
