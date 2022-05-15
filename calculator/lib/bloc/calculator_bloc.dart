import 'package:bloc/bloc.dart';
import '../models/CalculatorModel.dart';
import 'package:equatable/equatable.dart';

part 'calculator_event.dart';
part 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  String? _op;
  double? _prev;
  double? _curr;

  CalculatorModel _update({required double num}) {
    return CalculatorModel(result: num);
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

  // Initializes the calculator
  CalculatorBloc() : super(CalculatorInitial()) {
    on<LoadCalculator>((event, emit) async {
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(const CalculatorLoaded(calculator: CalculatorModel()));
    });

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
                _prev = res;
                _curr = null;
              } else {
                _prev = state.calculator.result;
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
                _prev = double.parse(newVal);
              } else {
                newVal = (_curr ?? 0).toString() +
                    Buttons.values[event.buttonIndex].value;
                _curr = double.parse(newVal);
              }
              newCalc = _update(num: double.parse(newVal));
              break;
            }
        }

        emit(CalculatorLoaded(calculator: (newCalc ?? state.calculator)));
      }
    });
  }
}
