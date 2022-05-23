import 'package:calculator/data_management/ManageData.dart';
import 'package:calculator/WidgetTree.dart';
import 'package:calculator/bloc/calculator_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data_management/UserPreferences.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences.init();
  ManageData.init();

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
      child: MaterialApp(
        title: 'ProtoCalculator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const WidgetTree(title: 'ProtoCalculator'),
      ),
    );
  }
}
