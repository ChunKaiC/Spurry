import 'package:calculator/bloc/calculator_bloc.dart';
import 'package:calculator/models/CalculatorModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Calculator.dart';

const int resultHeight = 168;

class WidgetTree extends StatelessWidget {
  const WidgetTree({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    // return BlocBuilder<CalculatorBloc, CalculatorState>(
    //     builder: (context, state) {
    //   if (state is CalculatorInitial) {
    //     return const CircularProgressIndicator(color: Colors.red);
    //   } else if (state is CalculatorLoaded) {
    //     return const CircularProgressIndicator(color: Colors.blue);
    //   } else {
    //     return const Text("Something bad happened :(");
    //   }
    // });

    return Calculator(title: title);
  }
}
