import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum SignInStates {
  notSignedIn,
  signedIn,
  signingIn,
}

enum SignInType {
  apple,
  google,
  anon,
}

class SignInProvider extends ChangeNotifier {
  SignInStates state = SignInStates.notSignedIn;
  SignInType? type;

  googleLogin() async {
    state = SignInStates.signingIn;
    type = SignInType.google;

    final googleSignIn = GoogleSignIn();

    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);

    state = SignInStates.signedIn;
    notifyListeners();
  }

  Future logout() async {
    if (type == SignInType.google) {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.disconnect();
    } else if (type == SignInType.apple) {
      print('Signing out from apple device!');
    }
    FirebaseAuth.instance.signOut();
  }

  appleLogin() async {
    state = SignInStates.signingIn;
    type = SignInType.apple;

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

    state = SignInStates.signingIn;
    notifyListeners();
  }

  anonLogin() async {
    state = SignInStates.signingIn;
    type = SignInType.apple;

    await FirebaseAuth.instance.signInAnonymously();

    state = SignInStates.signingIn;
    notifyListeners();
  }
}
