import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipiebook/models/favorite.dart';
import 'package:recipiebook/models/recipe.dart';
import 'package:recipiebook/utils/locator.dart';
import 'package:recipiebook/services/app_services.dart';
import 'package:recipiebook/utils/settings.dart';

class AppProvider with ChangeNotifier {
  AppServices _appServices = locator<AppServices>();

  List<RecipeKeyword> _recipes = [];
  List<RecipeKeyword> get recipes => _recipes;
  List<RecipeKeyword> _favoriteRecipes = [];
  List<RecipeKeyword> get favoriteRecipes => _favoriteRecipes;
  List<Favorite> _favorites = [];
  List<Favorite> get favorites => _favorites;

  Future<void> authenticate() => _appServices.authenticate();
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

  Future<void> addRecipeToFavorite(String recipeId) =>
      _appServices.addRecipeToFavorite(recipeId, Settings.userId);
  Future<void> removeRecipeFromFavorite(String recipeId) {
    final favoriteId = _favorites.firstWhere((f) => f.recipeId == recipeId).id;
    return _appServices.removeRecipeFromFavorite(favoriteId);
  }

  Future<void> getRecipes() async {
    _appServices.getRecipes().asBroadcastStream().listen(
      (recipes) {
        _recipes = [...recipes];
        _recipes
            .sort((a, b) => b.recipe.modifiedOn.compareTo(a.recipe.modifiedOn));

        getFavorites();
        notifyListeners();
      },
    );
  }

  Future<void> getFavorites() async {
    _appServices.getFavorites().asBroadcastStream().listen(
      (favorites) {
        _favorites = favorites;
        final favoriteRecipes = _recipes
            .where((r) => favorites.any((f) => f.recipeId == r.recipe.id))
            .toList();
        _favoriteRecipes = favoriteRecipes;
        notifyListeners();
      },
    );
  }

  Future<UploadTask> uploadFile(PickedFile file, String title) async =>
      _appServices.uploadFile(file, title);
}
