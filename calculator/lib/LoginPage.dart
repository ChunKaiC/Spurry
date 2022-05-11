import 'package:calculator/GoogleSignInProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Login Page')),
        ),
        body: Center(
          child: ElevatedButton.icon(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              },
              icon: FaIcon(FontAwesomeIcons.google),
              label: Text('Login with Google')),
        ));
  }
}
