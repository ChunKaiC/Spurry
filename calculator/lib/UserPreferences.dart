import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences pref;
  static const _resultKey = 'resultkey';

  static Future init() async {
    pref = await SharedPreferences.getInstance();
  }

  static Future setResult(result) async {
    await pref.setDouble(_resultKey, result);
  }

  static double? getResult() {
    return pref.getDouble(_resultKey);
  }
}
