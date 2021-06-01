import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static SharedPreferences sharedPrefs;
  static Future init() async =>
      sharedPrefs = await SharedPreferences.getInstance();
  static const String APP_INIT = 'app_init';
  static const String USER_ID = 'user_id';

  static set isAppInit(bool isAppInit) =>
      sharedPrefs.setBool(APP_INIT, isAppInit);

  static bool get isAppInit => sharedPrefs.getBool(APP_INIT) ?? true;
  static set userId(String userId) => sharedPrefs.setString(APP_INIT, userId);

  static String get userId => sharedPrefs.getString(APP_INIT) ?? '';
}
