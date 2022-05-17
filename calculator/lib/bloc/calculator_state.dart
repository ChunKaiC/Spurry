part of 'calculator_bloc.dart';

abstract class CalculatorState extends Equatable {
  const CalculatorState();

  @override
  List<Object> get props => [];
}

class CalculatorInitial extends CalculatorState {}

class CalculatorLogin extends CalculatorState {}

class CalculatorLoading extends CalculatorState {
  final LoginMethod method;

  const CalculatorLoading({required this.method});

  @override
  List<Object> get props => [method];
}

class CalculatorLoaded extends CalculatorState {
  final CalculatorModel calculator;
  final String lightMode;

  const CalculatorLoaded(
      {required this.calculator, this.lightMode = 'Light Mode'});

  @override
  List<Object> get props => [calculator, lightMode];
}
