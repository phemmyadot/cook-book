import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:recipiebook/models/favorite.dart';
import 'package:recipiebook/models/recipe.dart';
import 'package:recipiebook/models/user.dart';
import 'package:recipiebook/utils/locator.dart';
import 'package:recipiebook/services/app_services.dart';
import 'package:recipiebook/utils/settings.dart';

class AppProvider with ChangeNotifier {
  AppServices _appServices = locator<AppServices>();

  List<RecipeKeyword> _backupRecipes = [];
  List<RecipeKeyword> _recipes = [];
  List<RecipeKeyword> get recipes => _recipes;
  List<RecipeKeyword> _favoriteRecipes = [];
  List<RecipeKeyword> _backupFavoriteRecipes = [];
  List<RecipeKeyword> get favoriteRecipes => _favoriteRecipes;
  List<Favorite> _favorites = [];
  List<Favorite> get favorites => _favorites;
  bool _showLoading = false;
  bool get showLoading => _showLoading;
  List<UserModel> _users;
  List<UserModel> get users => _users;

  Future<void> authenticate() => _appServices.authenticate();
  Future<void> getAllUsers() async {
    _users = await _appServices.getAllUsers();
    notifyListeners();
  }

  Future<void> registerUserProfile(String userName, String userId) async =>
      _appServices.registerUserProfile(userName, userId, await getToken());

  Future<String> getToken() async {
    FirebaseMessaging.instance.requestPermission(
        sound: true, badge: true, alert: true, provisional: true);
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> addRecipe(
    String title,
    String link,
    String creator,
    String userId,
    List<String> keywords,
  ) =>
      _appServices.addRecipe(title, link, creator, userId, keywords, _users);

  Future<void> addRecipeToFavorite(String recipeId) =>
      _appServices.addRecipeToFavorite(recipeId, RBSettings.userId);

  Future<void> removeRecipeFromFavorite(String recipeId) {
    final favoriteId = _favorites.firstWhere((f) => f.recipeId == recipeId).id;
    return _appServices.removeRecipeFromFavorite(favoriteId);
  }

  Future<void> deleteRecipe(String recipeId) =>
      _appServices.deleteRecipe(recipeId);

  Future<void> getRecipes() async {
    _showLoading = true;
    _appServices.getRecipes().asBroadcastStream().listen(
      (recipes) {
        _backupRecipes = recipes;
        _recipes = [...recipes];
        _recipes
            .sort((a, b) => b.recipe.modifiedOn.compareTo(a.recipe.modifiedOn));

        getFavorites();
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
        _backupFavoriteRecipes = favoriteRecipes;
        _favoriteRecipes
            .sort((a, b) => b.recipe.modifiedOn.compareTo(a.recipe.modifiedOn));

        _showLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> searchRecipes(String searchQuery) async {
    if (searchQuery == '') {
      await getRecipes();
    } else {
      var keywords = searchQuery.split(',');
      List<RecipeKeyword> recipes = [];

      for (int i = 0; i < keywords.length; i++) {
        var found = _backupRecipes
            .where((RecipeKeyword data) => data.recipe.title
                .toLowerCase()
                .contains(keywords[i].toLowerCase().replaceFirst(' ', '')))
            .toList();
        for (int j = 0; j < _backupRecipes.length; j++) {
          var hasMatch = _backupRecipes[j].keywords.any((u) => u.keyword
              .toLowerCase()
              .contains(keywords[i].toLowerCase().replaceFirst(' ', '')));
          if (hasMatch) found.add(_backupRecipes[j]);
        }
        recipes = [...recipes, ...found];
      }
      List<RecipeKeyword> _distinct = [];
      var idSet = <String>{};
      for (var r in recipes) {
        if (idSet.add(r.recipe.id)) {
          _distinct.add(r);
        }
      }
      _recipes = _distinct;
      _recipes
          .sort((a, b) => b.recipe.modifiedOn.compareTo(a.recipe.modifiedOn));
    }
    notifyListeners();
  }

  Future<void> searchFavorites(String searchQuery) async {
    if (searchQuery == '') {
      getFavorites();
    } else {
      List<RecipeKeyword> favoriteRecipes = _backupFavoriteRecipes
          .where((RecipeKeyword data) => data.recipe.title
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
      for (int i = 0; i < _favoriteRecipes.length; i++) {
        var hasMatch = _favoriteRecipes[i].keywords.any(
            (u) => u.keyword.toLowerCase().contains(searchQuery.toLowerCase()));
        if (hasMatch) favoriteRecipes.add(_favoriteRecipes[i]);
      }
      List<RecipeKeyword> _distinct = [];
      var idSet = <String>{};
      for (var r in favoriteRecipes) {
        if (idSet.add(r.recipe.id)) {
          _distinct.add(r);
        }
      }
      _favoriteRecipes = favoriteRecipes;
      _favoriteRecipes
          .sort((a, b) => b.recipe.modifiedOn.compareTo(a.recipe.modifiedOn));
    }
    notifyListeners();
  }
}
