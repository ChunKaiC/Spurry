import 'package:cloud_firestore/cloud_firestore.dart';

class ManageData {
  static late FirebaseFirestore db;

  static void init() {
    db = FirebaseFirestore.instance;
    db.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
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

  static void updateLightMode(userLightMode, userEmail) {
    db.collection(userEmail).doc('lightMode').set(userLightMode);
  }

  static Future<String?> getLightMode(userEmail) async {
    final recentCalc = await db.collection(userEmail).doc('lightMode').get();

    if (recentCalc.data() == null) {
      return null;
    }
    return recentCalc.data()!['lightMode'];
  }
}
