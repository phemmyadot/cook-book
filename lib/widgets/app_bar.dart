import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isFavorite;
  CustomAppBar({Key key, this.isFavorite = false})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  TextEditingController _searchController = TextEditingController();
  final _searchKey = GlobalKey();

  void _searchRecipe() async {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              offset: Offset(0.0, 0.3),
              blurRadius: 2.0,
            ),
          ],
        ),
      ),
      centerTitle: true,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        height: 40.0,
        child: TextField(
          key: _searchKey,
          textCapitalization: TextCapitalization.sentences,
          controller: _searchController,
          style: TextStyle(
              fontSize: 16.0, height: 1.0, color: Colors.blueGrey[900]),
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green[500]),
              borderRadius: const BorderRadius.all(
                const Radius.circular(50.0),
              ),
            ),
            enabledBorder: new OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green[500]),
              borderRadius: const BorderRadius.all(
                const Radius.circular(50.0),
              ),
            ),
            focusedBorder: new OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green[500]),
              borderRadius: const BorderRadius.all(
                const Radius.circular(50.0),
              ),
            ),
            prefixIcon: IconButton(
              onPressed: () => _searchRecipe(),
              icon: Icon(
                Icons.search,
                size: 20,
                color: Colors.green[500],
              ),
            ),
            focusColor: Colors.green[500],
            hoverColor: Colors.green[500],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            isDense: true,
            filled: true,
            hintStyle: new TextStyle(color: Colors.blueGrey[900], height: 1.0),
            hintText:
                "Search ${widget.isFavorite ? 'from your favorites' : 'from all recipes'}",
            fillColor: Colors.white70,
          ),
        ),
      ),
      actions: <Widget>[
        Container(),
      ],
    );
  }
}
