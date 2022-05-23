import 'package:calculator/data_management/ManageData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:calculator/bloc/calculator_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const double topPad = 25;
const double infoHeight = 50;
const double resultHeight = 100;
const double avatarWidth = 100;
const double emailHeight = 25;

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
  final User? user = FirebaseAuth.instance.currentUser;
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
                              onPressed: () => context
                                  .read<CalculatorBloc>()
                                  .add(LoadSettings()),
                              child: const Text('Settings')),
                        ),
                      ),
                      const Expanded(child: Text('')),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: SizedBox(
                          height: infoHeight.toDouble(),
                          width: avatarWidth.toDouble() + 20,
                          child: const Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: MyDropDown()),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.bottomRight,
                    color: Colors.blue,
                    height: emailHeight,
                    width: queryData.size.width,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: Text(
                          'User: ${user == null ? 'Anonymous' : user!.email!}',
                          // ),
                          // width: 100,
                          // height: infoHeight.toDouble(),
                          // color: Colors.blue,
                          // alignment: Alignment.bottomRight,
                        ))),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 30, 15),
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
                  height: resultHeight - emailHeight,
                )
              ],
            ),

            /// button grid
            BlocBuilder<CalculatorBloc, CalculatorState>(
                builder: (context, state) {
              CalculatorLoaded curState = state as CalculatorLoaded;
              Color lightmode;

              if (curState.lightMode == 'Light Mode') {
                lightmode = Colors.white;
              } else {
                lightmode = Colors.grey[600] as Color;
              }

              return Container(
                height: queryData.size.height -
                    resultHeight -
                    topPad -
                    infoHeight -
                    emailHeight,
                width: queryData.size.width,
                color: lightmode,
                child: GridView.builder(
                  padding: const EdgeInsets.all(0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: (queryData.size.height -
                              resultHeight -
                              topPad -
                              infoHeight -
                              emailHeight) /
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
                ),
              );
            }),
          ],
        ));
  }
}

class MyDropDown extends StatefulWidget {
  const MyDropDown({Key? key}) : super(key: key);

  @override
  State<MyDropDown> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyDropDown> {
  String dropdownValue = 'Light Mode';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculatorBloc, CalculatorState>(
        builder: (context, state) {
      CalculatorLoaded currState = state as CalculatorLoaded;
      return DropdownButton<String>(
        value: currState.lightMode,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 2,
          color: Colors.black,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
            context
                .read<CalculatorBloc>()
                .add(UpdateLightMode(lightMode: newValue));
          });
        },
        items: <String>['Light Mode', 'Dark Mode']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }
}
