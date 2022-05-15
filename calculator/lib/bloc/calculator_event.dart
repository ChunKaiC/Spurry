part of 'calculator_bloc.dart';

abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object> get props => [];
}

class LoadCalculator extends CalculatorEvent {}

class OnPress extends CalculatorEvent {
  final int buttonIndex;

  const OnPress(this.buttonIndex);

  @override
  List<Object> get props => [buttonIndex];
}
