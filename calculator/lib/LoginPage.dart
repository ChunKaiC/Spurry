import 'package:calculator/SignInProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Login Page')),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const SizedBox(
                width: 200,
                height: 200,
                child: FlutterLogo(),
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                  onPressed: () {
                    final provider =
                        Provider.of<SignInProvider>(context, listen: false);
                    provider.googleLogin();
                  },
                  icon: const FaIcon(FontAwesomeIcons.google),
                  label: const Text('Login/Signup with Google')),
              Platform.isIOS
                  ? ElevatedButton.icon(
                      onPressed: () {
                        final provider =
                            Provider.of<SignInProvider>(context, listen: false);
                        provider.appleLogin();
                      },
                      icon: const FaIcon(FontAwesomeIcons.apple),
                      label: const Text('Login/Signup with Apple ID'))
                  : Container(),
              ElevatedButton.icon(
                onPressed: () {
                  final provider =
                      Provider.of<SignInProvider>(context, listen: false);
                  provider.anonLogin();
                },
                icon: const FaIcon(FontAwesomeIcons.question),
                label: const Text('Proceed without logging in'),
              ),
            ],
          ),
        ));
  }
}
