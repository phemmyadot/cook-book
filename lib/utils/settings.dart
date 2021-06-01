import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static SharedPreferences sharedPrefs;
  static Future init() async =>
      sharedPrefs = await SharedPreferences.getInstance();
  static const String APP_INIT = 'app_init';

  static set isAppInit(bool isAppInit) =>
      sharedPrefs.setBool(APP_INIT, isAppInit);

  static bool get isAppInit => sharedPrefs.getBool(APP_INIT) ?? true;
}
