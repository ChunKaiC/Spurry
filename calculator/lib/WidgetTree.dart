import 'package:calculator/bloc/calculator_bloc.dart';
import 'package:calculator/pages/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pages/CalculatorPage.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return BlocBuilder<CalculatorBloc, CalculatorState>(
        builder: (context, state) {
      if (state is CalculatorInitial) {
        return const Center(
            child: CircularProgressIndicator(color: Colors.blue));
      } else if (state is CalculatorLogin) {
        return const LoginPage();
      } else if (state is CalculatorLoaded) {
        return CalculatorPage(title: title);
      } else {
        return const Text("Something bad happened :(");
      }
    });
  }
}
