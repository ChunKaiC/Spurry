// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'CalculatorModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CalculatorModel {
  double get result => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CalculatorModelCopyWith<CalculatorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalculatorModelCopyWith<$Res> {
  factory $CalculatorModelCopyWith(
          CalculatorModel value, $Res Function(CalculatorModel) then) =
      _$CalculatorModelCopyWithImpl<$Res>;
  $Res call({double result});
}

/// @nodoc
class _$CalculatorModelCopyWithImpl<$Res>
    implements $CalculatorModelCopyWith<$Res> {
  _$CalculatorModelCopyWithImpl(this._value, this._then);

  final CalculatorModel _value;
  // ignore: unused_field
  final $Res Function(CalculatorModel) _then;

  @override
  $Res call({
    Object? result = freezed,
  }) {
    return _then(_value.copyWith(
      result: result == freezed
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$$_CalculatorModelCopyWith<$Res>
    implements $CalculatorModelCopyWith<$Res> {
  factory _$$_CalculatorModelCopyWith(
          _$_CalculatorModel value, $Res Function(_$_CalculatorModel) then) =
      __$$_CalculatorModelCopyWithImpl<$Res>;
  @override
  $Res call({double result});
}

/// @nodoc
class __$$_CalculatorModelCopyWithImpl<$Res>
    extends _$CalculatorModelCopyWithImpl<$Res>
    implements _$$_CalculatorModelCopyWith<$Res> {
  __$$_CalculatorModelCopyWithImpl(
      _$_CalculatorModel _value, $Res Function(_$_CalculatorModel) _then)
      : super(_value, (v) => _then(v as _$_CalculatorModel));

  @override
  _$_CalculatorModel get _value => super._value as _$_CalculatorModel;

  @override
  $Res call({
    Object? result = freezed,
  }) {
    return _then(_$_CalculatorModel(
      result: result == freezed
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_CalculatorModel
    with DiagnosticableTreeMixin
    implements _CalculatorModel {
  const _$_CalculatorModel({required this.result});

  @override
  final double result;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CalculatorModel(result: $result)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CalculatorModel'))
      ..add(DiagnosticsProperty('result', result));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CalculatorModel &&
            const DeepCollectionEquality().equals(other.result, result));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(result));

  @JsonKey(ignore: true)
  @override
  _$$_CalculatorModelCopyWith<_$_CalculatorModel> get copyWith =>
      __$$_CalculatorModelCopyWithImpl<_$_CalculatorModel>(this, _$identity);
}

abstract class _CalculatorModel implements CalculatorModel {
  const factory _CalculatorModel({required final double result}) =
      _$_CalculatorModel;

  @override
  double get result => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CalculatorModelCopyWith<_$_CalculatorModel> get copyWith =>
      throw _privateConstructorUsedError;
}
