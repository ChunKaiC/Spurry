import 'package:calculator/ManageData.dart';
import 'package:calculator/SignInProvider.dart';
import 'package:calculator/pages/LoginPage.dart';
import 'package:calculator/UserPreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:calculator/WidgetTree.dart';
import 'package:calculator/bloc/calculator_bloc.dart';
import 'package:calculator/models/CalculatorModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const int topPad = 20;
const int infoHeight = 50;
const int resultHeight = 100;
const int avatarWidth = 100;

enum Buttons {
  seven,
  eight,
  nine,
  mult,
  four,
  five,
  six,
  div,
  one,
  two,
  three,
  sub,
  clear,
  zero,
  eq,
  add,
}

extension GetVal on Buttons {
  String get value {
    switch (this) {
      case Buttons.one:
        return '1';
      case Buttons.two:
        return '2';
      case Buttons.three:
        return '3';
      case Buttons.four:
        return '4';
      case Buttons.five:
        return '5';
      case Buttons.six:
        return '6';
      case Buttons.seven:
        return '7';
      case Buttons.eight:
        return '8';
      case Buttons.nine:
        return '9';
      case Buttons.zero:
        return '0';
      case Buttons.clear:
        return 'C';
      case Buttons.mult:
        return 'x';
      case Buttons.div:
        return '/';
      case Buttons.sub:
        return '-';
      case Buttons.add:
        return '+';
      case Buttons.eq:
        return '=';
    }
  }
}

class CalculatorPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  CalculatorPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Column(
              children: [
                Container(height: topPad.toDouble(), color: Colors.blue),
                Container(
                  color: Colors.blue,
                  child: Row(
                    children: [
                      SizedBox(
                        height: infoHeight.toDouble(),
                        width: avatarWidth.toDouble() + 20,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: ElevatedButton(
                              onPressed: () =>
                                  context.read<CalculatorBloc>().add(Logout()),
                              child: const Text('Logout!')),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: Text(
                                'User: ${user!.email!}',
                                // ),
                                // width: 100,
                                // height: infoHeight.toDouble(),
                                // color: Colors.blue,
                                // alignment: Alignment.bottomRight,
                              ))),
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 22, 42, 20),
                    child: BlocBuilder<CalculatorBloc, CalculatorState>(
                        builder: (context, state) {
                      if (state is CalculatorInitial) {
                        return const CircularProgressIndicator(
                            color: Colors.blue);
                      } else if (state is CalculatorLoaded) {
                        return Text(
                          '${state.calculator.result}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 50,
                              fontWeight: FontWeight.bold),
                        );
                      } else {
                        return const Text("Something bad happened :(");
                      }
                    }),
                  ),
                  color: Colors.blue,
                  // color: const Color(0xFFF8F8F8),
                  width: queryData.size.width,
                  alignment: Alignment.bottomRight,
                  height: resultHeight.toDouble(),
                )
              ],
            ),

            /// button grid
            Flexible(
                flex: 3,
                child: GridView.builder(
                  padding: const EdgeInsets.all(0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: (queryData.size.height -
                              resultHeight -
                              topPad -
                              infoHeight) /
                          4,
                      crossAxisCount: 4),
                  itemCount: Buttons.values.length,
                  itemBuilder: (_, index) {
                    return TextButton(
                        onPressed: () =>
                            context.read<CalculatorBloc>().add(OnPress(index)),
                        child: Text(
                          Buttons.values[index].value,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 37,
                              fontWeight: FontWeight.bold),
                        ));
                  },
                  physics: const NeverScrollableScrollPhysics(),
                )),
          ],
        ));
  }
}
