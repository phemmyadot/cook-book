import 'package:recipiebook/screens/add_recipe.dart';
import 'package:recipiebook/utils/app_colors.dart';
import 'package:recipiebook/widgets/app_bar.dart';
import 'package:recipiebook/widgets/bottom_nav.dart';
import 'package:recipiebook/screens/recipe_page.dart';
import 'package:flutter/material.dart';

class EntryScreen extends StatefulWidget {
  static const routeName = '/entry';
  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  bool _isFavorite = false;
  initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  Future<void> _setCurrentIndex(int index, bool animate) async {
    if (animate) _tabController.animateTo(index);

    setState(() {
      _isFavorite = index == 1;
      _currentIndex = index;
      _searchController.text = '';
    });
  }

  _showAddModal() {
    showModalBottomSheet(
      context: context,
      barrierColor: AppColors.white.withOpacity(0.1),
      backgroundColor: AppColors.white.withOpacity(0.9),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return AddRecipe();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isFavorite: _isFavorite,
        searchController: _searchController,
      ),
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddModal();
        },
        child: Icon(
          Icons.add,
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        elevation: 2.0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.bg1, AppColors.bg2],
            ),
          ),
          child: new TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              for (int i = 0; i < getItems(_isFavorite).length; i++)
                getItems(_isFavorite).map((e) => e.page).toList()[i]
            ],
          ),
        ),
      ),
      bottomNavigationBar: _createBottomNavigationBar(
        _currentIndex,
      ),
    );
  }

  Widget _createBottomNavigationBar(int _currentIndex) {
    return Builder(builder: (BuildContext context) {
      return Container(
        child: FABBottomAppBar(
          backgroundColor: AppColors.white,
          color: AppColors.inactive,
          selectedColor: AppColors.primary,
          notchedShape: CircularNotchedRectangle(),
          onTabSelected: (index) async {
            switch (index) {
              default:
                _setCurrentIndex(index, true);
                break;
            }
          },
          items: [
            for (int i = 0; i < getItems(_isFavorite).length; i++)
              FABBottomAppBarItem(
                  iconData: getItems(_isFavorite)[i].icon, text: ''),
          ],
        ),
      );
    });
  }

  List<TabNavigationItem> getItems(isFavorite) => [
        TabNavigationItem(
          page: RecipePage(isFavorite: false),
          icon: Icons.home,
          title: "Home",
          padding: 8,
        ),
        TabNavigationItem(
          page: RecipePage(isFavorite: true),
          icon: Icons.favorite_sharp,
          title: "Favourite",
          padding: 8,
        ),
      ];
}

class TabNavigationItem {
  final Widget page;
  final String title;
  final IconData icon;
  final double padding;
  final GlobalKey key;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
    @required this.padding,
    this.key,
  });
}
