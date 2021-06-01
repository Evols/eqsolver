
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

@immutable
class Equation {
  final Expression leftPart;
  final Expression rightPart;

  Equation.fromParts(List<Expression> parts) : leftPart = parts[0], rightPart = parts[1];

  List<Expression> get parts => [leftPart, rightPart];

  Expression? findTree(bool Function(Expression) recurser) => leftPart.findTree(recurser) ?? rightPart.findTree(recurser) ?? null;

  Equation mountAt(Expression at, Expression toMount) => Equation(leftPart.mountAt(at, toMount), rightPart.mountAt(at, toMount));

  Equation deepClone() => Equation(leftPart.deepClone(), rightPart.deepClone());

  const Equation(this.leftPart, this.rightPart);

  
  @override
  String toString() {
    return 'Equation( $leftPart, $rightPart )';
  }
}
