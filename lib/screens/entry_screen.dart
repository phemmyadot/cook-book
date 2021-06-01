import 'package:cookbook/widgets/app_bar.dart';
import 'package:cookbook/widgets/bottom_nav.dart';
import 'package:cookbook/screens/recipe_page.dart';
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
  bool _isFavorite = false;
  FocusNode _focusNode = FocusNode();

  initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  Future<void> _setCurrentIndex(int index, bool animate) async {
    if (animate) _tabController.animateTo(index);

    setState(() {
      _isFavorite = index == 1;
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isFavorite: _isFavorite),
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.green[500],
          elevation: 2.0),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white70, Colors.grey[200]],
            ),
          ),
          child: new TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              for (int i = 0; i < getItems().length; i++)
                getItems().map((e) => e.page).toList()[i]
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
          backgroundColor: Colors.white,
          color: Colors.grey[500],
          selectedColor: Colors.green[400],
          notchedShape: CircularNotchedRectangle(),
          onTabSelected: (index) async {
            switch (index) {
              default:
                _setCurrentIndex(index, true);
                break;
            }
          },
          items: [
            for (int i = 0; i < getItems().length; i++)
              FABBottomAppBarItem(iconData: getItems()[i].icon, text: ''),
          ],
        ),
      );
    });
  }

  List<TabNavigationItem> getItems() => [
        TabNavigationItem(
          page: RecipePage(),
          icon: Icons.home,
          title: "Home",
          padding: 8,
        ),
        TabNavigationItem(
          page: RecipePage(isFavorite: _isFavorite),
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
