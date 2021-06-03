import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Keyword {
  final String id;
  final String recipeId;
  final String keyword;
  final String createdBy;
  final DateTime createdOn;
  final String modifiedBy;
  final DateTime modifiedOn;

  const Keyword({
    this.id,
    @required this.recipeId,
    @required this.keyword,
    @required this.createdBy,
    @required this.createdOn,
    @required this.modifiedBy,
    @required this.modifiedOn,
  });

  Keyword.fromData(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        recipeId = snapshot.data()['recipeId'],
        keyword = snapshot.data()['keyword'],
        createdBy = snapshot.data()['createdBy'],
        createdOn = snapshot.data()['createdOn'].toDate(),
        modifiedBy = snapshot.data()['modifiedBy'],
        modifiedOn = snapshot.data()['modifiedOn'].toDate();

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'keyword': keyword,
      'createdBy': createdBy,
      'createdOn': createdOn,
      'modifiedBy': modifiedBy,
      'modifiedOn': modifiedOn,
    };
  }
}
