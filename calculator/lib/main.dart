import 'package:calculator/WidgetTree.dart';
import 'package:calculator/bloc/calculator_bloc.dart';
import 'package:calculator/models/CalculatorModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'SignInProvider.dart';
import 'UserPreferences.dart';
import 'package:firebase_core/firebase_core.dart';

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CalculatorBloc()..add(Initialize()))
        ],
        child: ChangeNotifierProvider(
          create: (context) => SignInProvider(),
          child: MaterialApp(
            title: 'ProtoCalculator',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const WidgetTree(title: 'ProtoCalculator'),
          ),
        ));
  }
}
