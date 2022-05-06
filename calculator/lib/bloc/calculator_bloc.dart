import 'package:bloc/bloc.dart';
import '../models/calculator.dart';
import 'package:equatable/equatable.dart';

part 'calculator_event.dart';
part 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  // Initializes the calculator
  CalculatorBloc() : super(CalculatorInitial()) {
    on<LoadCalculator>((event, emit) async {
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(const CalculatorLoaded(calculator: Calculator()));
    });

    on<OnPress>((event, emit) {
      if (state is CalculatorLoaded) {
        final state = this.state as CalculatorLoaded;
        emit(CalculatorLoaded(calculator: state.calculator.));
      }
    });
  }
}
