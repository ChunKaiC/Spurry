import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Calculator extends Equatable {
  final double _result = 0;
  final String? _op = null;
  final double? _prev = null;
  final double? _curr = null;

  const Calculator();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
