import 'package:calculator/bloc/calculator_bloc.dart';
import 'package:calculator/data_management/ManageData.dart';
import 'package:calculator/pages/LoginPage.dart';
import 'package:calculator/pages/SettingPage.dart';
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
        return Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (state is CalculatorLogin) {
        return const LoginPage();
      } else if (state is CalculatorLoading) {
        return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasData ||
                state.method == LoginMethod.unsigned) {
              context.read<CalculatorBloc>().add(Load());
              return Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: Text('Something went wrong :('),
                ),
              );
            } else {
              return const LoginPage();
            }
          },
        );
      } else if (state is CalculatorLoaded) {
        return CalculatorPage(title: title);
      } else if (state is CalculatorSettings) {
        return const SettingPage();
      } else {
        return const Text("Something bad happened :(");
      }
    });
  }
}
