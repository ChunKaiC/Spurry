part of 'calculator_bloc.dart';

abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object> get props => [];
}

class Initialize extends CalculatorEvent {}

class Login extends CalculatorEvent {
  final LoginMethod method;

  const Login(this.method);

  @override
  List<Object> get props => [method];
}

class Logout extends CalculatorEvent {}

class OnPress extends CalculatorEvent {
  final int buttonIndex;

  const OnPress(this.buttonIndex);

  @override
  List<Object> get props => [buttonIndex];
}

class Load extends CalculatorEvent {}

class UpdateLightMode extends CalculatorEvent {
  final String lightMode;

  const UpdateLightMode({required this.lightMode});

  @override
  List<Object> get props => [lightMode];
}
