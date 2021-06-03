import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static SharedPreferences sharedPrefs;
  static Future init() async =>
      sharedPrefs = await SharedPreferences.getInstance();
  static const String APP_INIT = 'app_init';
  static const String USER_ID = 'user_id';
  static const String USER_NAME = 'username';

  static set isAppInit(bool isAppInit) =>
      sharedPrefs.setBool(APP_INIT, isAppInit);
  static bool get isAppInit => sharedPrefs.getBool(APP_INIT) ?? true;

  static set userId(String userId) => sharedPrefs.setString(USER_ID, userId);
  static String get userId => sharedPrefs.getString(USER_ID) ?? '';

  static set username(String username) =>
      sharedPrefs.setString(USER_NAME, username);
  static String get username => sharedPrefs.getString(USER_NAME) ?? '';
}
