import 'package:flutter/material.dart';

int counter = 0;
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
  '',
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
  String _display = '0';
  String _op = '';
  int prev = -1;
  int curr = -1;

  void change(String num) {
    setState(() {
      _display = num;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          /// The result tab
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 88, 42, 20),
              child: Text(
                _display.toString(),
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

          /// The buttons
          Flexible(
              flex: 3,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemCount: buttonVals.length,
                itemBuilder: (_, index) {
                  if (buttonVals[index] == 'x') {
                    return TextButton(
                        onPressed: () {
                          null;
                        },
                        child: Text(buttonVals[index]));
                  } else if (buttonVals[index] == '/') {
                    return TextButton(
                        onPressed: () {
                          null;
                        },
                        child: Text(buttonVals[index]));
                  } else if (buttonVals[index] == '-') {
                    return TextButton(
                        onPressed: () {
                          null;
                        },
                        child: Text(buttonVals[index]));
                  } else if (buttonVals[index] == '+') {
                    return TextButton(
                        onPressed: () {
                          null;
                        },
                        child: Text(buttonVals[index]));
                  } else if (buttonVals[index] == '=') {
                    return TextButton(
                        onPressed: () {
                          null;
                        },
                        child: Text(buttonVals[index]));
                  } else {
                    return TextButton(
                        onPressed: () {
                          change(buttonVals[index]);
                        },
                        child: Text(buttonVals[index]));
                  }
                },
                physics: const NeverScrollableScrollPhysics(),
              ))
        ]));
  }
}
