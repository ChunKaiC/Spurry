import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const int resultHeight = 168;

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
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CalculatorProvider())],
      child: const MyApp()));
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

// Main widget
class Calculator extends StatelessWidget {
  const Calculator({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          /// result tab
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 88, 42, 20),
              // Consumer, used for minimal re-renderingr
              child: Consumer<CalculatorProvider>(
                builder: (context, provider, child) => Text(
                  (provider.result).toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            color: const Color(0xFFF8F8F8),
            width: queryData.size.width,
            alignment: Alignment.bottomRight,
            height: resultHeight.toDouble(),
          ),

          /// button grid
          Expanded(
              flex: 3,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: (queryData.size.height - resultHeight) / 4,
                    crossAxisCount: 4),
                itemCount: Buttons.values.length,
                itemBuilder: (_, index) {
                  return TextButton(
                      onPressed: () => context
                          .read<CalculatorProvider>()
                          ._onPressFunction(index: index),
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
        ]));
  }
}

// Provider, handles logic
class CalculatorProvider with ChangeNotifier {
  double _result = 0;
  String? _op;
  double? _prev;
  double? _curr;

  double get result => _result;

  void _update({required double num}) {
    _result = num;
    notifyListeners();
  }

  double _eval({required String op, required double x, required double y}) {
    if (op == 'x') {
      return (x * y).toDouble();
    } else if (op == '/') {
      return x / y;
    } else if (op == '-') {
      return (x - y).toDouble();
    }
    return (x + y).toDouble();
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
            _prev = res;
            _curr = null;
          } else {
            _prev = _result;
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
          break;
        }

      case Buttons.clear:
        // Reset
        {
          _update(num: 0);
          _op = _prev = _curr = null;
          break;
        }

      default:
        // General buttons
        {
          String newVal;
          if (_op == null) {
            newVal = (_prev ?? 0).toString() + Buttons.values[index].value;
            _prev = double.parse(newVal);
          } else {
            newVal = (_curr ?? 0).toString() + Buttons.values[index].value;
            _curr = double.parse(newVal);
          }
          _update(num: double.parse(newVal));
          break;
        }
    }
  }
}
