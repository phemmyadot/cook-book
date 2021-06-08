import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:recipiebook/app.dart';
import 'package:recipiebook/providers/app_provider.dart';
import 'package:recipiebook/utils/locator.dart';
import 'package:recipiebook/utils/settings.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  setupLocator();
  await RBSettings.init();

  await runZonedGuarded(() async {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => AppProvider()),
        ],
        child: MyApp(),
      ),
    );
  }, (Object error, StackTrace stackTrace) async {
    print(error.toString());
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
