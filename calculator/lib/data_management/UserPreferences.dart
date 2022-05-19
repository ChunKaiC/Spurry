import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences pref;
  static const _resultKey = 'resultkey';
  static const _historyKey = "historyKey";
  static const _lightModeKey = "lightModekey";
  static const _userKey = "userKey";
  static const _syncKey = 'syncKey';

  static Future init() async {
    pref = await SharedPreferences.getInstance();
  }

  static Future setLightMode(lightMode) async {
    await pref.setString(_lightModeKey, lightMode);
  }

  static String? getLightMode() {
    return pref.getString(_lightModeKey);
  }

  static Future setUser(user) async {
    await pref.setString(_userKey, user);
  }

  static String? getUser() {
    return pref.getString(_userKey);
  }

  static Future setSync(isSync) async {
    await pref.setBool(_syncKey, isSync);
  }

  static bool? getSync() {
    return pref.getBool(_syncKey);
  }
}