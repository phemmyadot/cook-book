import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:recipiebook/models/http_exception.dart';
import 'package:recipiebook/models/recipe.dart';
import 'package:recipiebook/providers/app_provider.dart';
import 'package:recipiebook/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:recipiebook/utils/app_dialog.dart';
import 'package:recipiebook/utils/date_formatter.dart';
import 'package:recipiebook/utils/settings.dart';
import 'package:recipiebook/utils/string_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeCard extends StatefulWidget {
  final bool isFavorite;
  final RecipeKeyword data;
  RecipeCard(this.isFavorite, this.data);
  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard>
    with SingleTickerProviderStateMixin {
  bool _loaded = false;
  // var image;
  AnimationController controller;
  initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    if (widget.data.recipe.hasNetworkImage) {
      Image.network(widget.data.recipe.imageLink)
          .image
          .resolve(new ImageConfiguration())
          .addListener(ImageStreamListener((ImageInfo info, bool _) {
        controller.stop();
        if (mounted) {
          setState(() => _loaded = true);
        }
      }));
    }

    super.initState();
  }

  dispose() {
    controller.dispose();
    super.dispose();
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
    } on HttpException catch (_) {
      RBDialog.showErrorDialog(context, RBStringUtils.erorOcurred);
    } catch (e) {
      RBDialog.showErrorDialog(context, e.toString());
    }
  }

  Future<void> _launchURL(String url) async {
    // if (await canLaunch(url)) {
    await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(widget.data.recipe.link),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: RBColors.white,
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
                      color: RBColors.primary.withOpacity(0.7),
                    ),
                    child: Center(
                      child: Text(getInitials(widget.data.recipe.creatorName),
                          style: TextStyle(
                              color: RBColors.white,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        RBDateFormatter(widget.data.recipe.modifiedOn).format(),
                        style: TextStyle(
                            fontSize: 11.0, fontWeight: FontWeight.w400),
                      ),
                      Text(
                          truncateWithEllipsis(
                              15, widget.data.recipe.creatorName),
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  if (!widget.data.recipe.hasNetworkImage)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 130,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(widget.data.recipe.imageLink)),
                      ),
                    )
                  else if (widget.data.recipe.hasNetworkImage && _loaded)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 130,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.data.recipe.imageLink)),
                      ),
                    )
                  else
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 130,
                      child: AnimatedBuilder(
                        animation: controller,
                        builder: (context, child) {
                          return FractionallySizedBox(
                            widthFactor: .5,
                            alignment: AlignmentGeometryTween(
                              begin: Alignment(-1.0 - .2 * 3, .0),
                              end: Alignment(1.0 + .2 * 3, .0),
                            )
                                .chain(CurveTween(curve: Curves.easeOut))
                                .evaluate(controller),
                            child: child,
                          );
                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                RBColors.primary.withOpacity(0.01),
                                RBColors.primary.withOpacity(0.02),
                                RBColors.primary.withOpacity(0.03),
                                RBColors.primary.withOpacity(0.03),
                                RBColors.primary.withOpacity(0.04),
                                RBColors.primary.withOpacity(0.05),
                                RBColors.primary.withOpacity(0.06),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 130,
                  //   child: Center(
                  //     child: CircularProgressIndicator(
                  //       valueColor: AlwaysStoppedAnimation<Color>(
                  //           RBColors.primary.withOpacity(0.8)),
                  //       // value: downloadProgress.progress,
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: RBColors.white.withOpacity(0.7),
                      ),
                      child: IconButton(
                          icon: Icon(
                            hasFavorite
                                ? Icons.favorite_sharp
                                : Icons.favorite_outline_sharp,
                            color: RBColors.primary,
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
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          for (int i = 0; i < widget.data.keywords.length; i++)
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: RBColors.primary.withOpacity(0.8),
                              ),
                              child: Text(
                                widget.data.keywords[i].keyword,
                                style: TextStyle(
                                    color: RBColors.white, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (RBSettings.userId == widget.data.recipe.createdBy)
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever_outlined,
                        color: RBColors.error.withOpacity(0.7),
                        size: 18,
                      ),
                      onPressed: () =>
                          Provider.of<AppProvider>(context, listen: false)
                              .deleteRecipe(widget.data.recipe.id),
                    )
                ],
              ),
              SizedBox(height: 10)
            ],
          )),
    );
  }
}
