import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CalculatorModel extends Equatable {
  final double result;

  const CalculatorModel({this.result = 0});

  @override
  List<Object> get props => [result];
}
