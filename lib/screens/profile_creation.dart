import 'package:cookbook/screens/entry_screen.dart';
import 'package:cookbook/utils/settings.dart';
import 'package:flutter/material.dart';

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
    _usernameController.clear();
    Settings.isAppInit = false;
    Navigator.of(context).pushNamedAndRemoveUntil(
      EntryScreen.routeName,
      (Route<dynamic> route) => false,
    );
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
              'Welcome to Cook Book,',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5.0),
            Text(
              'set you username to proceed.',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30.0),
            Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: TextFormField(
                key: _usernameKey,
                textCapitalization: TextCapitalization.sentences,
                controller: _usernameController,
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
                  suffixIcon: IconButton(
                    onPressed: () => _createProfile(),
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Colors.green[500],
                    ),
                  ),
                  focusColor: Colors.green[500],
                  hoverColor: Colors.green[500],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  isDense: true,
                  filled: true,
                  hintStyle:
                      new TextStyle(color: Colors.blueGrey[900], height: 1.0),
                  hintText: "Enter you username",
                  fillColor: Colors.white70,
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
      return 'Field is required';
    }
    return null;
  }
}
