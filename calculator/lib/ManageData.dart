import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageData {
  static late FirebaseFirestore db;

  static void init() {
    db = FirebaseFirestore.instance;
  }

  static void update(userCalculation, userEmail, date) {
    db.collection(userEmail).doc(date.toString()).set(userCalculation);

    db.collection(userEmail).doc('result').set(userCalculation);
  }

  static Future<double?> getRecent(userEmail) async {
    final recentCalc = await db.collection(userEmail).doc('result').get();

    if (recentCalc.data() == null) {
      return null;
    }
    return recentCalc.data()!['result'];
  }
}
