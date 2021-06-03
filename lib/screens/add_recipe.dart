import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipiebook/providers/app_provider.dart';
import 'package:recipiebook/utils/app_colors.dart';
import 'package:recipiebook/utils/settings.dart';
import 'package:recipiebook/utils/string_utils.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final ImagePicker _picker = ImagePicker();
  PickedFile _image;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  final _titleKey = GlobalKey();
  final _linkKey = GlobalKey();
  final _keywordKey = GlobalKey();
  List<String> _keywords = [];
  bool _hasLinkError = false;
  bool _hasKeywordsError = false;

  initState() {
    _image = null;
    super.initState();
  }

  void _imgFromCamera(_setState) async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    _setState(() {
      _image = image;
    });
  }

  void _imgFromGallery(_setState) async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    _setState(() => _image = image);
  }

  validateForm() {
    if (_keywords.length < 1)
      _hasKeywordsError = true;
    else
      _hasKeywordsError = false;
    if (_linkController.text.isEmpty)
      _hasLinkError = true;
    else
      _hasLinkError = false;
    setState(() => null);
  }

  void _addRecipe() async {
    validateForm();
    if (_hasKeywordsError || _hasLinkError) return;
    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      var imagePath = 'assets/images/sample.jpg';
      if (_image != null) {
        final image = await provider.uploadFile(
            _image,
            _titleController.text.isEmpty
                ? _linkController.text
                : _titleController.text);
        imagePath = await image.snapshot.ref.getDownloadURL();
      }
      await provider.addRecipe(
        _titleController.text.isEmpty ? imagePath : _titleController.text,
        imagePath,
        _linkController.text,
        Settings.username,
        Settings.userId,
        _keywords,
        _image != null,
      );
      Navigator.pop(context);
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
                  StringUtils.addRecipeTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkPrimary,
                      fontSize: 24),
                ),
                SizedBox(height: 40),
                Text(
                  StringUtils.titleText,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkPrimary),
                ),
                SizedBox(height: 5),
                _textField(_titleKey, _titleController,
                    StringUtils.titleHintText, false),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      StringUtils.linkText,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkPrimary),
                    ),
                    SizedBox(width: 3),
                    Text(
                      '*',
                      style: TextStyle(fontSize: 12, color: AppColors.error),
                    ),
                    SizedBox(width: 10),
                    !_hasLinkError
                        ? SizedBox()
                        : Text(
                            StringUtils.requiredField,
                            style:
                                TextStyle(fontSize: 12, color: AppColors.error),
                          ),
                  ],
                ),
                SizedBox(height: 5),
                _textField(
                    _linkKey, _linkController, StringUtils.linkHintText, true),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      StringUtils.keyWordText,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkPrimary),
                    ),
                    SizedBox(width: 3),
                    Text(
                      '*',
                      style: TextStyle(fontSize: 12, color: AppColors.error),
                    ),
                    SizedBox(width: 10),
                    !_hasKeywordsError
                        ? SizedBox()
                        : Text(
                            'This field is required',
                            style:
                                TextStyle(fontSize: 12, color: AppColors.error),
                          ),
                  ],
                ),
                SizedBox(height: 5),
                TextFieldTags(
                  key: _keywordKey,
                  tagsStyler: TagsStyler(
                    tagDecoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    tagCancelIcon: Icon(Icons.cancel,
                        size: 18.0, color: AppColors.white.withOpacity(0.5)),
                    tagPadding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    tagTextPadding: EdgeInsets.only(right: 5),
                  ),
                  textFieldStyler: TextFieldStyler(
                    cursorColor: AppColors.primary,
                    textFieldFilledColor: AppColors.bg2,
                    textFieldFilled: true,
                    textStyle: TextStyle(
                      color: AppColors.inactive,
                      height: 1.0,
                    ),
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
                    hintText: StringUtils.keyWordHintText,
                    helperText: '',
                    hintStyle:
                        TextStyle(color: AppColors.inactive, height: 1.0),
                  ),
                  onTag: (tag) {
                    _keywords.add(tag);
                    validateForm();
                  },
                  onDelete: (tag) {
                    _keywords.remove(tag);
                    validateForm();
                  },
                ),
                Text(
                  StringUtils.uploadNote,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkPrimary),
                ),
                SizedBox(height: 5),
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
                          onPressed: () => _addRecipe(),
                          child: Text(
                            'Save',
                            style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
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
  }

  Widget _textField(key, controller, String hintText, bool validate) {
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
      onChanged: (_) => validate ? validateForm() : null,
    );
  }
}
