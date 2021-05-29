
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

@immutable
class Equation {
  final Expression leftPart;
  final Expression rightPart;

  List<Expression> get parts => [leftPart, rightPart];

  Expression? findTree(bool Function(Expression) recurser) => leftPart.findTree(recurser) ?? rightPart.findTree(recurser) ?? null;

  Equation mountAt(Expression at, Expression toMount) => Equation(leftPart.mountAt(at, toMount), rightPart.mountAt(at, toMount));

  Equation deepClone() => Equation(leftPart.deepClone(), rightPart.deepClone());

  Equation(this.leftPart, this.rightPart);
}
