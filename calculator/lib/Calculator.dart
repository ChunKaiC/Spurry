import 'package:calculator/SignInProvider.dart';
import 'package:calculator/LoginPage.dart';
import 'package:calculator/UserPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class Calculator extends StatefulWidget {
  const Calculator({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final user = FirebaseAuth.instance.currentUser;
  double _result = UserPreferences.getResult() ?? 0;
  String? _op;
  String? _prev;
  String? _curr;

  void _update({required double num}) {
    setState(() {
      _result = num;
    });
  }

  double _eval({required String op, required String x, required String y}) {
    double res;

    if (op == 'x') {
      res = (double.parse(x) * double.parse(y));
    } else if (op == '/') {
      res = (double.parse(x) / double.parse(y));
    } else if (op == '-') {
      res = (double.parse(x) - double.parse(y));
    } else {
      res = (double.parse(x) + double.parse(y));
    }

    UserPreferences.setResult(res);
    UserPreferences.addHistory(
        "${double.parse(x)} $op ${double.parse(y)} = $res");

    return res;
  }

  void _onPressFunction({required int index}) {
    switch (Buttons.values[index]) {
      case Buttons.mult:
      case Buttons.div:
      case Buttons.sub:
      case Buttons.add:

        /// Op
        {
          if (_prev != null && _op != null && _curr != null) {
            double res = _eval(op: _op!, x: _prev!, y: _curr!);
            _update(num: res);
            _prev = res.toString();
            _curr = null;
          } else {
            _prev = _result.toString();
            _curr = null;
          }
          _op = Buttons.values[index].value;
          break;
        }

      case Buttons.eq:
        // Eval
        {
          if (_prev != null && _op != null && _curr != null) {
            _update(num: _eval(op: _op!, x: _prev!, y: _curr!));
            _op = _prev = _curr = null;
          }

          print(UserPreferences.getHistory());

          break;
        }

      case Buttons.clear:
        // Reset
        {
          UserPreferences.setResult(0.0);
          UserPreferences.pref.remove('historyKey');
          _update(num: 0);
          _op = _prev = _curr = null;
          break;
        }

      default:
        // General buttons
        {
          String newVal;
          if (_op == null) {
            newVal = (_prev ?? '0').toString() + Buttons.values[index].value;
            _prev = newVal;
          } else {
            newVal = (_curr ?? '0').toString() + Buttons.values[index].value;
            _curr = newVal;
          }
          _update(num: double.parse(newVal));
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Column(children: [
      /// result tab
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
                        onPressed: () {
                          final provider = Provider.of<SignInProvider>(context,
                              listen: false);
                          provider.logout();
                        },
                        child: const Text('Logout!')),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Text('User: ' +
                      ((user!.email != null ? user!.email! : 'Anonymous'))),
                  // ),
                  // width: 100,
                  // height: infoHeight.toDouble(),
                  // color: Colors.blue,
                  // alignment: Alignment.bottomRight,
                )),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 22, 42, 20),
              child: Text(
                _result.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
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
                  onPressed: () => _onPressFunction(index: index),
                  child: Text(
                    Buttons.values[index].value,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 37,
                        fontWeight: FontWeight.bold),
                  ));
            },
            physics: const NeverScrollableScrollPhysics(),
          ))
    ]);
  }
}
