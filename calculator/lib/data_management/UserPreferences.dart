import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences pref;
  static const _resultKey = 'resultkey';
  static const _historyKey = "historyKey";
  static const _lightModeKey = "lightModekey";
  static const _userKey = "userKey";

  static Future init() async {
    pref = await SharedPreferences.getInstance();
  }

  static Future setResult(result) async {
    await pref.setDouble(_resultKey, result);
  }

  static double? getResult() {
    return pref.getDouble(_resultKey);
  }

  static Future addHistory(hist) async {
    List<String>? oldHistory = pref.getStringList(_historyKey);

    await pref.setStringList(_historyKey, (oldHistory ?? []) + [hist]);
  }

  static List<String>? getHistory() {
    return pref.getStringList(_historyKey);
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
}
