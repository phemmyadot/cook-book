import 'dart:async';
import 'package:cookbook/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  // setupLocator();
  // await st.Settings.init();

  // if (userFirestoreEmulator) {
  //   FirebaseFirestore.instance.settings = Settings(
  //       host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  // }
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await runZonedGuarded(() async {
    runApp(MyApp()
        // MultiProvider(
        //   providers: [
        //     // ChangeNotifierProvider(create: (ctx) => ThemeProvider()),
        //   ],
        //   child: MyApp(),
        // ),
        );
  }, (Object error, StackTrace stackTrace) async {
    print(error.toString());
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
