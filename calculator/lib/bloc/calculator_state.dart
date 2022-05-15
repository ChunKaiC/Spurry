part of 'calculator_bloc.dart';

abstract class CalculatorState extends Equatable {
  const CalculatorState();

  @override
  List<Object> get props => [];
}

class CalculatorInitial extends CalculatorState {}

class CalculatorLogin extends CalculatorState {}

class CalculatorLoaded extends CalculatorState {
  final CalculatorModel calculator;
  final User? user;

  const CalculatorLoaded({required this.calculator, required this.user});

  @override
  List<Object> get props => [calculator];
}
