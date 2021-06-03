import 'package:provider/provider.dart';
import 'package:recipiebook/providers/app_provider.dart';
import 'package:recipiebook/screens/entry_screen.dart';
import 'package:recipiebook/utils/app_colors.dart';
import 'package:recipiebook/utils/settings.dart';
import 'package:recipiebook/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:recipiebook/utils/string_utils.dart';
import 'package:uuid/uuid.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profiles';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _usernameController = TextEditingController();
  final _usernameKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  Future<void> _createProfile() async {
    setState(() => _autoValidate = true);
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    final _userId = Uuid().v1();
    try {
      await context
          .read<AppProvider>()
          .registerUserProfile(_usernameController.text, _userId);
      Settings.userId = _userId;
      Settings.username = _usernameController.text;
      _usernameController.clear();
      Settings.isAppInit = false;
      Navigator.of(context).pushNamedAndRemoveUntil(
        EntryScreen.routeName,
        (Route<dynamic> route) => false,
      );
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringUtils.welcomeNote1,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5.0),
            Text(
              StringUtils.welcomeNote2,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30.0),
            Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: TextFormField(
                key: _usernameKey,
                onFieldSubmitted: (_) => _createProfile(),
                textCapitalization: TextCapitalization.sentences,
                controller: _usernameController,
                style: TextStyle(
                    fontSize: 16.0, height: 1.0, color: AppColors.inactive),
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
                  suffixIcon: IconButton(
                    onPressed: () => _createProfile(),
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  focusColor: AppColors.primary,
                  hoverColor: AppColors.primary,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  isDense: true,
                  filled: true,
                  hintStyle:
                      new TextStyle(color: AppColors.inactive, height: 1.0),
                  hintText: StringUtils.usernameHintText,
                  fillColor: AppColors.bg2,
                ),
                validator: (value) => _validatorFn(value),
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }

  String _validatorFn(String value) {
    if (value.isEmpty) {
      return StringUtils.requiredField;
    }
    return null;
  }
}
