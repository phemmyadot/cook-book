import 'package:cookbook/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './utils/routes.dart' as rt;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cook Book',
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
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Be Still',
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
