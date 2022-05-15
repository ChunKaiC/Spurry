import 'package:calculator/bloc/calculator_bloc.dart';
import 'package:calculator/models/CalculatorModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => CalculatorBloc()..add(LoadCalculator()))
      ],
      child: MaterialApp(
        title: 'ProtoCalculator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(title: 'BLoC Calculator'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

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
              child: BlocBuilder<CalculatorBloc, CalculatorState>(
                  builder: (context, state) {
                if (state is CalculatorInitial) {
                  return const CircularProgressIndicator(color: Colors.blue);
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
              ))
        ]));
  }
}
