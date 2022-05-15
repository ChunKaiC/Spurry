part of 'calculator_bloc.dart';

abstract class CalculatorState extends Equatable {
  const CalculatorState();

  @override
  List<Object> get props => [];
}

class CalculatorInitial extends CalculatorState {}

class CalculatorLoaded extends CalculatorState {
  final CalculatorModel calculator;

  const CalculatorLoaded({required this.calculator});

  @override
  List<Object> get props => [calculator];
}
