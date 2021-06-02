import 'package:recipiebook/utils/app_colors.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatefulWidget {
  final bool isFavorite;
  RecipeCard(this.isFavorite);
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
                Row(
                  children: [
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.primary.withOpacity(0.7),
                      ),
                      child: Text('JD',
                          style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(width: 5),
                    Text(truncateWithEllipsis(15, 'John Doe Username'),
                        style: TextStyle(fontSize: 14.0)),
                    SizedBox(width: 10),
                  ],
                ),
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
                          widget.isFavorite
                              ? Icons.favorite_sharp
                              : Icons.favorite_outline_sharp,
                          color: AppColors.primary,
                        ),
                        onPressed: null),
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
                        widget.isFavorite
                            ? 'test this'
                            : truncateWithEllipsis(
                                25, 'Title of Recipe lon version hggggg'),
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
