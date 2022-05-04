import 'package:flutter/material.dart';

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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProtoCalculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Calculator(title: 'ProtoCalculator'),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  double result = 0;
  String? op;
  double? prev;
  double? curr;

  void _update(double num) {
    setState(() {
      result = num;
    });
  }

  double _eval(String op, double x, double y) {
    if (op == 'x') {
      return (x * y).toDouble();
    } else if (op == '/') {
      return x / y;
    } else if (op == '-') {
      return (x - y).toDouble();
    }
    return (x + y).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          /// result tab
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 88, 42, 20),
              child: Text(
                result.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontFamily: "SF-Mono",
                    fontWeight: FontWeight.bold),
              ),
            ),
            color: const Color(0xFFF8F8F8),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomRight,
            height: 168,
          ),

          /// button grid
          Expanded(
              flex: 3,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemCount: Buttons.values.length,
                itemBuilder: (_, index) {
                  void Function()? onPressFunction;

                  switch (Buttons.values[index]) {
                    case Buttons.mult:
                    case Buttons.div:
                    case Buttons.sub:
                    case Buttons.add:

                      /// Op
                      onPressFunction = () {
                        if (prev != null && op != null && curr != null) {
                          double res = _eval(op!, prev!, curr!);
                          _update(res);
                          prev = res;
                          curr = null;
                        } else {
                          prev = result;
                          curr = null;
                        }
                        op = Buttons.values[index].value;
                      };
                      break;

                    case Buttons.eq:
                      // Eval
                      onPressFunction = () {
                        if (prev != null && op != null && curr != null) {
                          _update(_eval(op!, prev!, curr!));
                          op = prev = curr = null;
                        }
                      };
                      break;

                    case Buttons.clear:
                      // Reset
                      onPressFunction = () {
                        _update(0);
                        op = prev = curr = null;
                      };
                      break;

                    default:
                      // General buttons
                      onPressFunction = () {
                        String newVal;
                        if (op == null) {
                          newVal = (prev ?? 0).toString() +
                              Buttons.values[index].value;
                          prev = double.parse(newVal);
                        } else {
                          newVal = (curr ?? 0).toString() +
                              Buttons.values[index].value;
                          curr = double.parse(newVal);
                        }
                        _update(double.parse(newVal));

                        // print('Previous; $prev');
                        // print('Op: $op');
                        // print('Current: $curr');
                      };
                      break;
                  }

                  return TextButton(
                      onPressed: onPressFunction,
                      child: Text(
                        Buttons.values[index].value,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 37,
                            fontFamily: "SF-Mono",
                            fontWeight: FontWeight.bold),
                      ));
                },
                physics: const NeverScrollableScrollPhysics(),
              ))
        ]));
  }
}
