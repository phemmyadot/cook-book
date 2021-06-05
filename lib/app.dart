import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:recipiebook/screens/add_recipe.dart';
import 'package:recipiebook/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipiebook/utils/app_colors.dart';
import './utils/routes.dart' as rt;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipie Book',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription _intentDataStreamSubscription;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value != null)
        showModalBottomSheet(
          context: context,
          barrierColor: AppColors.white.withOpacity(0.1),
          backgroundColor: AppColors.white.withOpacity(0.9),
          isScrollControlled: true,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AddRecipe(link: value);
            });
          },
        );
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value != null)
        showModalBottomSheet(
          context: context,
          barrierColor: AppColors.white.withOpacity(0.1),
          backgroundColor: AppColors.white.withOpacity(0.9),
          isScrollControlled: true,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AddRecipe(link: value);
            });
          },
        );
    });
    super.initState();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipie Book',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Avenir Next',
        appBarTheme: AppBarTheme(
          color: Color(0xFFFFFFFF),
        ),
      ),
      initialRoute: '/',
      routes: rt.routes,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => SplashScreen());
      },
    );
  }
}
