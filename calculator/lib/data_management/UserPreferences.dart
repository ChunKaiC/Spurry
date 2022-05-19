import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserPreferences {
  static late SharedPreferences pref;
  static late FlutterSecureStorage storage;
  static const _lightModeKey = "lightModekey";
  static const _userKey = "userKey";
  static const _syncKey = 'syncKey';

  static Future init() async {
    pref = await SharedPreferences.getInstance();
    storage = new FlutterSecureStorage();
  }

  static Future setLightMode(lightMode) async {
    await pref.setString(_lightModeKey, lightMode);
  }

  static String? getLightMode() {
    return pref.getString(_lightModeKey);
  }

  static Future setUser(user) async {
    await storage.write(key: _userKey, value: user);
  }

  static Future<String?> getUser() async {
    final uid = await storage.read(key: _userKey);
    return uid;
  }

  static Future setSync(isSync) async {
    await pref.setBool(_syncKey, isSync);
  }

  static bool? getSync() {
    return pref.getBool(_syncKey);
  }
}
