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
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(image: AssetImage('assets/images/sample.jpg')),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        widget.isFavorite
                            ? 'test this'
                            : truncateWithEllipsis(
                                30, 'Title of Recipe lon version hggggg'),
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
                    // SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Username', style: TextStyle(fontSize: 14.0)),
                        IconButton(
                            icon: Icon(
                              widget.isFavorite
                                  ? Icons.favorite_sharp
                                  : Icons.favorite_outline_sharp,
                              color: Colors.green[400],
                            ),
                            onPressed: null)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
