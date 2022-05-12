import 'package:calculator/GoogleSignInProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Login Page')),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    final provider =
                        Provider.of<SignInProvider>(context, listen: false);
                    provider.googleLogin();
                  },
                  icon: const FaIcon(FontAwesomeIcons.google),
                  label: const Text('Login/Signup with Google')),
              ElevatedButton.icon(
                  onPressed: () {
                    final provider =
                        Provider.of<SignInProvider>(context, listen: false);
                    provider.appleLogin();
                  },
                  icon: const FaIcon(FontAwesomeIcons.google),
                  label: const Text('Login/Signup with Apple ID')),
            ],
          ),
        ));
  }
}
