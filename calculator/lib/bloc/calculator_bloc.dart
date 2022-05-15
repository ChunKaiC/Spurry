import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/CalculatorModel.dart';
import 'package:equatable/equatable.dart';

part 'calculator_event.dart';
part 'calculator_state.dart';

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

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  String? _op;
  String? _prev;
  String? _curr;

  CalculatorModel _update({required double num}) {
    return CalculatorModel(result: num);
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

    // UserPreferences.setResult(res);
    // UserPreferences.addHistory(
    //     "${double.parse(x)} $op ${double.parse(y)} = $res");

    final DateTime date = DateTime.now();

    // To save history
    final userCalculation = <String, dynamic>{
      "x": double.parse(x),
      'operation': op,
      'y': double.parse(y),
      "result": res,
    };

    //ManageData.update(userCalculation, user!.email!, date);

    return res;
  }

  // Initializes the calculator
  CalculatorBloc() : super(CalculatorInitial()) {
    on<OnPress>((event, emit) {
      if (state is CalculatorLoaded) {
        final state = this.state as CalculatorLoaded;

        // Make new calculator
        CalculatorModel? newCalc;

        switch (Buttons.values[event.buttonIndex]) {
          case Buttons.mult:
          case Buttons.div:
          case Buttons.sub:
          case Buttons.add:

            /// Op
            {
              if (_prev != null && _op != null && _curr != null) {
                double res = _eval(op: _op!, x: _prev!, y: _curr!);
                newCalc = _update(num: res);
                _prev = res.toString();
                _curr = null;
              } else {
                _prev = state.calculator.result.toString();
                _curr = null;
              }
              _op = Buttons.values[event.buttonIndex].value;
              break;
            }

          case Buttons.eq:
            // Eval
            {
              if (_prev != null && _op != null && _curr != null) {
                newCalc = _update(num: _eval(op: _op!, x: _prev!, y: _curr!));
                _op = _prev = _curr = null;
              }
              break;
            }

          case Buttons.clear:
            // Reset
            {
              newCalc = _update(num: 0);
              _op = _prev = _curr = null;
              break;
            }

          default:
            // General buttons
            {
              String newVal;
              if (_op == null) {
                newVal = (_prev ?? 0).toString() +
                    Buttons.values[event.buttonIndex].value;
                _prev = newVal;
              } else {
                newVal = (_curr ?? 0).toString() +
                    Buttons.values[event.buttonIndex].value;
                _curr = newVal;
              }
              newCalc = _update(num: double.parse(newVal));
              break;
            }
        }

        emit(CalculatorLoaded(
            calculator: (newCalc ?? state.calculator), user: state.user));
      }
    });

    on<Initialize>((event, emit) async {
      await Future<void>.delayed(const Duration(seconds: 2));
      emit(CalculatorLogin());
    });

    on<Login>(((event, emit) async {
      emit(CalculatorLoaded(
          calculator: const CalculatorModel(),
          user: FirebaseAuth.instance.currentUser));
    }));

    on<Logout>(((event, emit) async {
      FirebaseAuth.instance.signOut();
      emit(CalculatorLogin());
    }));
  }
}
