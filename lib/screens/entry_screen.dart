import 'dart:io';

import 'package:recipiebook/utils/app_colors.dart';
import 'package:recipiebook/widgets/app_bar.dart';
import 'package:recipiebook/widgets/bottom_nav.dart';
import 'package:recipiebook/screens/recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';

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
  final ImagePicker _picker = ImagePicker();
  PickedFile _image;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  final _titleKey = GlobalKey();
  final _linkKey = GlobalKey();
  final _keywordKey = GlobalKey();
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

  _showAddModal() {
    showModalBottomSheet(
      context: context,
      barrierColor: AppColors.white.withOpacity(0.1),
      backgroundColor: AppColors.white.withOpacity(0.9),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Add new recipe',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkPrimary,
                            fontSize: 24),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Title',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkPrimary),
                      ),
                      SizedBox(height: 5),
                      _textField(_titleKey, _titleController, 'Title'),
                      SizedBox(height: 20),
                      Text(
                        'Link',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkPrimary),
                      ),
                      SizedBox(height: 5),
                      _textField(_linkKey, _linkController, 'Link'),
                      SizedBox(height: 20),
                      Text(
                        'Keywords',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkPrimary),
                      ),
                      SizedBox(height: 5),
                      TextFieldTags(
                        key: _keywordKey,
                        tagsStyler: TagsStyler(
                            tagTextStyle:
                                TextStyle(fontWeight: FontWeight.bold),
                            tagDecoration: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            tagCancelIcon: Icon(Icons.cancel,
                                size: 18.0, color: Colors.blue[900]),
                            tagPadding: const EdgeInsets.all(6.0)),
                        textFieldStyler: TextFieldStyler(
                          cursorColor: AppColors.primary,
                          textFieldFilledColor: AppColors.bg2,
                          textFieldFilled: true,
                          textStyle:
                              TextStyle(color: AppColors.inactive, height: 1.0),
                          textFieldEnabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(5.0),
                            ),
                          ),
                          textFieldFocusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(5.0),
                            ),
                          ),
                          isDense: true,
                          hintText: 'Keywords',
                          helperText: '',
                          hintStyle:
                              TextStyle(color: AppColors.inactive, height: 1.0),
                        ),
                        onTag: (tag) {
                          print('onTag ' + tag);
                        },
                        onDelete: (tag) {
                          print('onDelete ' + tag);
                        },
                      ),
                      InkWell(
                        onTap: () => _showPicker(context, setState),
                        child: _image != null
                            ? ClipRRect(
                                child: Image.file(
                                  File(_image.path),
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.fitWidth,
                                  alignment: FractionalOffset.topCenter,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                ),
                                width: 150,
                                height: 150,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              child: OutlinedButton(
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all<BorderSide>(
                                        BorderSide(color: AppColors.primary)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context)),
                            ),
                            SizedBox(
                              width: 100,
                              child: TextButton(
                                onPressed: null,
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          );
        });
      },
    );
  }

  _imgFromCamera(_setState) async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    _setState(() {
      _image = image;
    });
  }

  _imgFromGallery(_setState) async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    _setState(() => _image = image);
  }

  void _showPicker(context, setState) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery(setState);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(setState);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isFavorite: _isFavorite),
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _image = null;
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

  Widget _textField(key, controller, hintText) {
    return TextField(
      key: key,
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      style: TextStyle(fontSize: 16.0, height: 1.0, color: AppColors.inactive),
      decoration: new InputDecoration(
        border: new OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: const BorderRadius.all(
            const Radius.circular(5.0),
          ),
        ),
        enabledBorder: new OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: const BorderRadius.all(
            const Radius.circular(5.0),
          ),
        ),
        focusedBorder: new OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: const BorderRadius.all(
            const Radius.circular(5.0),
          ),
        ),
        focusColor: AppColors.primary,
        hoverColor: AppColors.primary,
        isDense: true,
        filled: true,
        hintStyle: new TextStyle(color: AppColors.inactive, height: 1.0),
        hintText: hintText,
        fillColor: AppColors.bg2,
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
