import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum SignInStates {
  notSignedIn,
  signedIn,
  signingIn,
}

class SignInProvider extends ChangeNotifier {
  SignInStates state = SignInStates.notSignedIn;

  googleLogin() async {
    state = SignInStates.signingIn;

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

  appleLogin() async {
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
}
