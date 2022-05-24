import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';

import 'UserPreferences.dart';

enum LoginMethod {
  google,
  apple,
  unsigned,
}

// This is a static singleton. Must be initialized in main.
class ManageData {
  static late FirebaseFirestore db;
  static LoginMethod? loginMethod;

  static Future _googleLogin() async {
    final googleSignIn = GoogleSignIn();

    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future _appleLogin() async {
    // authenticate login
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oAuthProvider = OAuthProvider('apple.com');

    final newCred = oAuthProvider.credential(
        accessToken: credential.authorizationCode,
        idToken: credential.identityToken);

    await FirebaseAuth.instance.signInWithCredential(newCred);
  }

  static Future _unsignedLogin() async {
    String? user = await UserPreferences.getUser();

    if (user == null) {
      print('CREATED NEW UID!');
      final uuid = Uuid();

      UserPreferences.setUser(uuid.v4());
    }
  }

  static void init() {
    // Initialized Firestore with offline persistence
    db = FirebaseFirestore.instance;
    db.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  }

  static Future login(LoginMethod method) async {
    loginMethod = method;

    // Login based on method chosen
    if (loginMethod == LoginMethod.google) {
      await _googleLogin();
    } else if (loginMethod == LoginMethod.apple) {
      await _appleLogin();
    } else if (loginMethod == LoginMethod.unsigned) {
      await _unsignedLogin();
    }

    // Perform sync if last session was unsigned
    if (loginMethod != LoginMethod.unsigned) {
      final bool isSync = UserPreferences.getSync() ?? true;

      if (!isSync) {
        // unisigned user has changes, therefore must sync
        final String unsignedUser = (await UserPreferences.getUser())!;
        final QuerySnapshot<Map<String, dynamic>> collection =
            await ManageData.getCollection(unsignedUser);

        // Append data to the signed in user
        for (var doc in collection.docs) {
          final converted = <String, dynamic>{
            "x": doc.data()['x'],
            'operation': doc.data()['operation'],
            'y': doc.data()['y'],
            "result": doc.data()['result'],
          };
          ManageData.update(
              converted, FirebaseAuth.instance.currentUser!.email!, doc.id);
          doc.reference.delete();
        }

        // Set sync to true
        UserPreferences.setSync(true);
      }
    }
  }

  static Future logout() async {
    // Log the user out of Firebase
    await FirebaseAuth.instance.signOut();
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

  static Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
      userEmail) async {
    QuerySnapshot<Map<String, dynamic>> collection =
        await db.collection(userEmail).get();

    return collection;
  }
}
