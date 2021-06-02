import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String id;
  final String userName;
  final String deviceId;
  final String token;
  final String createdBy;
  final DateTime createdOn;
  final String modifiedBy;
  final DateTime modifiedOn;

  const User({
    this.id,
    @required this.userName,
    @required this.deviceId,
    @required this.token,
    @required this.createdBy,
    @required this.createdOn,
    @required this.modifiedBy,
    @required this.modifiedOn,
  });

  User.fromData(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        userName = snapshot.data()['userName'],
        deviceId = snapshot.data()['deviceId'],
        token = snapshot.data()['token'],
        createdBy = snapshot.data()['createdBy'],
        createdOn = snapshot.data()['createdOn'].toDate(),
        modifiedBy = snapshot.data()['modifiedBy'],
        modifiedOn = snapshot.data()['modifiedOn'].toDate();

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'deviceId': deviceId,
      'token': token,
      'createdBy': createdBy,
      'createdOn': createdOn,
      'modifiedBy': modifiedBy,
      'modifiedOn': modifiedOn,
    };
  }
}
