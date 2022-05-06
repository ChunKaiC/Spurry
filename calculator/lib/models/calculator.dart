import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Calculator extends Equatable {
  final double result;

  const Calculator({this.result = 0});

  @override
  List<Object> get props => [result];
}
