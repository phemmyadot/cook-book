import 'package:provider/provider.dart';
import 'package:recipiebook/providers/app_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    final recipes =
        !widget.isFavorite ? Provider.of<AppProvider>(context).recipes : [];
    var smallestDimension = MediaQuery.of(context).size.shortestSide;
    final useMobileLayout = smallestDimension < 600;
    double _crossAxisSpacing = 10, _mainAxisSpacing = 20;
    int _crossAxisCount = useMobileLayout ? 2 : 3;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            key: refreshKey,
            onRefresh: () => null,
            child: GridView.count(
                childAspectRatio: screenWidth / (screenHeight - 50),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                primary: false,
                crossAxisSpacing: _crossAxisSpacing,
                mainAxisSpacing: _mainAxisSpacing,
                padding:
                    EdgeInsets.only(bottom: 50, left: 20, right: 20, top: 20),
                crossAxisCount: _crossAxisCount,
                children: <Widget>[
                  for (int i = 0; i < recipes.length; i++)
                    RecipeCard(widget.isFavorite, recipes[i]),
                ]),
          ),
        ),
      ],
    );
  }
}
