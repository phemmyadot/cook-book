import 'dart:async';
import 'package:provider/provider.dart';
import 'package:recipiebook/providers/app_provider.dart';
import 'package:recipiebook/screens/entry_screen.dart';
import 'package:recipiebook/screens/profile_creation.dart';
import 'package:recipiebook/utils/app_colors.dart';
import 'package:recipiebook/utils/settings.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        startTime();
      });
      setState(() => _isInit = false);
    }
    super.didChangeDependencies();
  }

  startTime() async {
    var duration = new Duration(seconds: 5);
    return new Timer(duration, () => route());
  }

  route() async {
    // Settings.isAppInit = true;
    if (Settings.isAppInit) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        ProfileScreen.routeName,
        (Route<dynamic> route) => false,
      );
    } else {
      await Provider.of<AppProvider>(context, listen: false).getRecipes();
      Navigator.of(context).pushNamedAndRemoveUntil(
        EntryScreen.routeName,
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: initScreen(context),
    );
  }

  initScreen(BuildContext context) {
    double targetValue = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient:
              RadialGradient(colors: [Color(0XFFFFFFFF), Color(0XFFC1C5C8)]),
        ),
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: targetValue),
                    onEnd: () => setState(() => targetValue = targetValue),
                    duration: Duration(seconds: 2),
                    builder: (BuildContext context, double size, Widget child) {
                      return Container(
                        child: Text('Recipie Book',
                            style: TextStyle(
                                fontSize: size,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500)),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}
