
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/values/value.dart';

@immutable
class Equation {
  final Value leftPart;
  final Value rightPart;

  List<Value> get parts => [leftPart, rightPart];

  Value? findTree(bool Function(Value) recurser) => leftPart.findTree(recurser) ?? rightPart.findTree(recurser) ?? null;

  Equation mountAt(Value at, Value toMount) => Equation(leftPart.mountAt(at, toMount), rightPart.mountAt(at, toMount));

  Equation deepClone() => Equation(leftPart.deepClone(), rightPart.deepClone());

  Equation(this.leftPart, this.rightPart);
}
