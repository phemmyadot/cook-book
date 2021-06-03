import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipiebook/models/recipe.dart';
import 'package:recipiebook/utils/locator.dart';
import 'package:recipiebook/services/app_services.dart';

class AppProvider with ChangeNotifier {
  AppServices _appServices = locator<AppServices>();

  List<RecipeKeyword> _recipes = [];
  List<RecipeKeyword> get recipes => _recipes;

  Future<void> registerUserProfile(String userName, String userId) =>
      _appServices.registerUserProfile(userName, userId);

  Future<void> addRecipe(
    String title,
    String imageLink,
    String link,
    String creator,
    String userId,
    List<String> keywords,
    bool hasNetworkImage,
  ) =>
      _appServices.addRecipe(
        title,
        imageLink,
        link,
        creator,
        userId,
        keywords,
        hasNetworkImage,
      );

  Future<void> addRecipeToFavorite(String recipeId, String userId) =>
      _appServices.addRecipeToFavorite(recipeId, userId);

  Future<void> getRecipes(String userId) async {
    _appServices.getRecipes(userId).asBroadcastStream().listen(
      (recipes) {
        _recipes = recipes;
        notifyListeners();
      },
    );
  }

  Future<UploadTask> uploadFile(PickedFile file) =>
      _appServices.uploadFile(file);
}
