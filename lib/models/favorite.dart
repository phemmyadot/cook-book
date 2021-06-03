import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Favorite {
  final String id;
  final String recipeId;
  final String createdBy;
  final DateTime createdOn;
  final String modifiedBy;
  final DateTime modifiedOn;

  const Favorite({
    this.id,
    @required this.recipeId,
    @required this.createdBy,
    @required this.createdOn,
    @required this.modifiedBy,
    @required this.modifiedOn,
  });

  Favorite.fromData(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        recipeId = snapshot.data()['recipeId'],
        createdBy = snapshot.data()['createdBy'],
        createdOn = snapshot.data()['createdOn'].toDate(),
        modifiedBy = snapshot.data()['modifiedBy'],
        modifiedOn = snapshot.data()['modifiedOn'].toDate();

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'createdBy': createdBy,
      'createdOn': createdOn,
      'modifiedBy': modifiedBy,
      'modifiedOn': modifiedOn,
    };
  }
}
