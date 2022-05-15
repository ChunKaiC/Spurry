import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

class UserCalculation {
  final String? op;
  final double? x;
  final double? y;
  final double? result;

  UserCalculation({this.op, this.x, this.y, this.result});

  // UserCalculation.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) :
}

class ManageData {
  static void update(userCalculation, userEmail, date) {
    db.collection(userEmail).doc(date.toString()).set(userCalculation);

    db.collection(userEmail).doc('result').set(userCalculation);
  }

  static Future<double> getRecent(userEmail) async {
    final recentCalc = await db.collection(userEmail).doc('result').get();
    print(recentCalc.data()!['result']);
    return recentCalc.data()!['result'];
  }
}
