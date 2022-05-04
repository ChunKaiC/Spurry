import 'package:flutter/material.dart';

final List<String> buttonVals = [
  '7',
  '8',
  '9',
  'x',
  '4',
  '5',
  '6',
  '/',
  '1',
  '2',
  '3',
  '-',
  'C',
  '0',
  '=',
  '+',
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Calculator(title: 'Flutter Demo Home Page'),
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
                itemCount: buttonVals.length,
                itemBuilder: (_, index) {
                  void Function()? onPressFunction;

                  double eval(String op, double x, double y) {
                    if (op == 'x') {
                      return (x * y).toDouble();
                    } else if (op == '/') {
                      return x / y;
                    } else if (op == '-') {
                      return (x - y).toDouble();
                    }
                    return (x + y).toDouble();
                  }

                  switch (buttonVals[index]) {
                    case 'x':
                    case '/':
                    case '-':
                    case '+':

                      /// Op
                      onPressFunction = () {
                        if (prev != null && op != null && curr != null) {
                          double res = eval(op!, prev!, curr!);
                          _update(res);
                          prev = res;
                          curr = null;
                        } else {
                          prev = result;
                          curr = null;
                        }
                        op = buttonVals[index];
                      };
                      break;

                    case '=':
                      // Eval
                      onPressFunction = () {
                        if (prev != null && op != null && curr != null) {
                          _update(eval(op!, prev!, curr!));
                          op = prev = curr = null;
                        }
                      };
                      break;

                    case 'C':
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
                          newVal = (prev ?? 0).toString() + buttonVals[index];
                          prev = double.parse(newVal);
                        } else {
                          newVal = (curr ?? 0).toString() + buttonVals[index];
                          curr = double.parse(newVal);
                        }
                        _update(double.parse(newVal));

                        print('Previous; $prev');
                        print('Op: $op');
                        print('Current: $curr');
                      };
                      break;
                  }

                  return TextButton(
                      onPressed: onPressFunction,
                      child: Text(
                        buttonVals[index],
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
