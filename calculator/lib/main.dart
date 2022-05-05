import 'package:flutter/material.dart';
import 'methods/state_calc.dart';

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
      home: const StateCalculator(title: 'ProtoCalculator'),
    );
  }
}
