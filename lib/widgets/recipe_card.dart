import 'package:provider/provider.dart';
import 'package:recipiebook/models/http_exception.dart';
import 'package:recipiebook/models/recipe.dart';
import 'package:recipiebook/providers/app_provider.dart';
import 'package:recipiebook/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:recipiebook/utils/settings.dart';

class RecipeCard extends StatefulWidget {
  final bool isFavorite;
  final RecipeKeyword data;
  RecipeCard(this.isFavorite, this.data);
  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  initState() {
    super.initState();
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  String getInitials(name) {
    List<String> names = name.split(" ");
    String initials = "";
    int numWords = names.length > 1 ? 2 : 1;
    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0]}';
    }
    return initials;
  }

  bool get hasFavorite {
    final favorites =
        Provider.of<AppProvider>(context, listen: false).favoriteRecipes;
    return favorites.any((f) => f.recipe.id == widget.data.recipe.id);
  }

  _favorite() {
    try {
      hasFavorite
          ? Provider.of<AppProvider>(context, listen: false)
              .removeRecipeFromFavorite(widget.data.recipe.id)
          : Provider.of<AppProvider>(context, listen: false)
              .addRecipeToFavorite(widget.data.recipe.id);
    } on HttpException catch (e, s) {
      print(e.toString());
      print(s.toString());
      // TODO Error dialog
    } catch (e, s) {
      print(e.toString());
      print(s.toString());
      // TODO Error dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: AppColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 10),
                Container(
                  height: 35,
                  width: 35,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.primary.withOpacity(0.7),
                  ),
                  child: Center(
                    child: Text(getInitials(widget.data.recipe.creatorName),
                        style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                SizedBox(width: 5),
                Text(truncateWithEllipsis(15, widget.data.recipe.creatorName),
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600)),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 10),
            Stack(
              children: [
                Image(image: AssetImage('assets/images/sample.jpg')),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.white.withOpacity(0.3),
                    ),
                    child: IconButton(
                        icon: Icon(
                          hasFavorite
                              ? Icons.favorite_sharp
                              : Icons.favorite_outline_sharp,
                          color: AppColors.primary,
                        ),
                        onPressed: () => _favorite()),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        truncateWithEllipsis(25, widget.data.recipe.title),
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  for (int i = 0; i < widget.data.keywords.length; i++)
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primary.withOpacity(0.8),
                      ),
                      child: Text(
                        widget.data.keywords[i].keyword,
                        style: TextStyle(color: AppColors.white, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 10)
          ],
        ));
  }
}
