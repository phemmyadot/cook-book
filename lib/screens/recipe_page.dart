import 'package:provider/provider.dart';
import 'package:recipiebook/models/http_exception.dart';
import 'package:recipiebook/providers/app_provider.dart';
import 'package:recipiebook/utils/app_colors.dart';
import 'package:recipiebook/utils/app_dialog.dart';
import 'package:recipiebook/utils/string_utils.dart';
import 'package:recipiebook/widgets/recipe_card.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatefulWidget {
  final bool isFavorite;
  RecipePage({this.isFavorite = false});
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final refreshKey = new GlobalKey<RefreshIndicatorState>();
  var _isInit = true;

  void didChangeDependencies() async {
    if (_isInit) {
      await _getRecipes();
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  Future<void> _getRecipes() async {
    try {
      await Provider.of<AppProvider>(context, listen: false).getRecipes();
    } on HttpException catch (_) {
      RBDialog.showErrorDialog(context, RBStringUtils.profileCreationError);
    } catch (e) {
      RBDialog.showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final recipes =
        !widget.isFavorite ? provider.recipes : provider.favoriteRecipes;
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;
    double _crossAxisSpacing = 10, _mainAxisSpacing = 20;
    int _crossAxisCount = useMobileLayout ? 2 : 3;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return provider.showLoading
        ? RBDialog.getLoading(context)
        : Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  key: refreshKey,
                  onRefresh: () => _getRecipes(),
                  child: recipes.length < 1
                      ? Center(
                          child: Text(
                            RBStringUtils.emptyList,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: RBColors.primary.withOpacity(0.3),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Container(
                          child: GridView.count(
                              childAspectRatio:
                                  screenWidth / (screenHeight - 50),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              primary: false,
                              crossAxisSpacing: _crossAxisSpacing,
                              mainAxisSpacing: _mainAxisSpacing,
                              padding: EdgeInsets.only(
                                  bottom: 50, left: 20, right: 20, top: 20),
                              crossAxisCount: _crossAxisCount,
                              children: <Widget>[
                                for (int i = 0; i < recipes.length; i++)
                                  RecipeCard(
                                    widget.isFavorite,
                                    recipes[i],
                                  ),
                              ]),
                        ),
                ),
              ),
            ],
          );
  }
}
