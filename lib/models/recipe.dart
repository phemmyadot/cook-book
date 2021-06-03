import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipiebook/models/favorite.dart';
import 'package:recipiebook/models/keyword.dart';

class Recipe {
  final String id;
  final String title;
  final String link;
  final String imageLink;
  final String creatorName;
  final bool hasNetworkImage;
  final String createdBy;
  final DateTime createdOn;
  final String modifiedBy;
  final DateTime modifiedOn;

  const Recipe({
    this.id,
    @required this.title,
    @required this.link,
    @required this.imageLink,
    @required this.creatorName,
    @required this.hasNetworkImage,
    @required this.createdBy,
    @required this.createdOn,
    @required this.modifiedBy,
    @required this.modifiedOn,
  });

  Recipe.fromData(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        title = snapshot.data()['title'],
        link = snapshot.data()['link'],
        imageLink = snapshot.data()['imageLink'],
        creatorName = snapshot.data()['creatorName'],
        hasNetworkImage = snapshot.data()['hasNetworkImage'],
        createdBy = snapshot.data()['createdBy'],
        createdOn = snapshot.data()['createdOn'].toDate(),
        modifiedBy = snapshot.data()['modifiedBy'],
        modifiedOn = snapshot.data()['modifiedOn'].toDate();

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'imageLink': imageLink,
      'creatorName': creatorName,
      'hasNetworkImage': hasNetworkImage,
      'createdBy': createdBy,
      'createdOn': createdOn,
      'modifiedBy': modifiedBy,
      'modifiedOn': modifiedOn,
    };
  }
}

class RecipeKeyword {
  final String id;
  final Recipe recipe;
  final List<Keyword> keywords;

  RecipeKeyword({
    this.id,
    this.recipe,
    this.keywords,
  });
}

class FavoriteRecipe {
  final String id;
  final Recipe recipe;
  final Favorite favorite;

  FavoriteRecipe({
    this.id,
    this.recipe,
    this.favorite,
  });
}
