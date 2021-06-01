import 'package:cookbook/utils/app_colors.dart';
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
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.inactive,
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
          style:
              TextStyle(fontSize: 16.0, height: 1.0, color: AppColors.inactive),
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
              borderRadius: const BorderRadius.all(
                const Radius.circular(50.0),
              ),
            ),
            enabledBorder: new OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
              borderRadius: const BorderRadius.all(
                const Radius.circular(50.0),
              ),
            ),
            focusedBorder: new OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
              borderRadius: const BorderRadius.all(
                const Radius.circular(50.0),
              ),
            ),
            prefixIcon: IconButton(
              onPressed: () => _searchRecipe(),
              icon: Icon(
                Icons.search,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            focusColor: AppColors.primary,
            hoverColor: AppColors.primary,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            isDense: true,
            filled: true,
            hintStyle: new TextStyle(color: AppColors.inactive, height: 1.0),
            hintText:
                "Search ${widget.isFavorite ? 'from your favorites' : 'from all recipes'}",
            fillColor: AppColors.bg2,
          ),
        ),
      ),
      actions: <Widget>[
        Container(),
      ],
    );
  }
}
