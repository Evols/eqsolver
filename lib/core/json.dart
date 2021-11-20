
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/core/expressions/gcd.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/named_constant.dart';
import 'package:formula_transformator/core/expressions/variable.dart';

List<Equation>? parseEquations(dynamic json) {
  if (json is List<dynamic>) {
    return json.map(
      (eqJson) => parseEquation(eqJson)
    ).whereType<Equation>().toList();
  }
}

Equation? parseEquation(dynamic json) {
  if (json is Map<String, dynamic>) {
    final leftPart = json['left'];
    final rightPart = json['right'];
    return Equation.fromParts([leftPart, rightPart].map(
      (part) => parseExpression(part)
    ).whereType<Expression>().toList());
  }
}

Expression? parseExpression(dynamic json) {
}

dynamic jsonifyEquations(List<Equation> equations) {
  return equations.map((equation) => jsonifyEquation(equation)).toList();
}

dynamic jsonifyEquation(Equation equation) {
  return {
    'left': jsonifyExpression(equation.leftPart),
    'right': jsonifyExpression(equation.rightPart),
  };
}

dynamic jsonifyExpression(Expression expression) {
  if (expression is NamedConstant) {
    return {
      'type': 'named_constant',
      'name': expression.name,
    };
  }
  if (expression is LiteralConstant) {
    return {
      'type': 'literal_constant',
      'name': expression.number.toString(),
    };
  }
  if (expression is Variable) {
    return {
      'type': 'variable',
      'name': expression.name,
    };
  }
  if (expression is Addition) {
    return {
      'type': 'addition',
      'terms': expression.terms.map(
        (term) => jsonifyExpression(term)
      ).toList(),
    };
  }
  if (expression is Multiplication) {
    return {
      'type': 'multiplication',
      'terms': expression.factors.map(
        (term) => jsonifyExpression(term)
      ).toList(),
    };
  }
  if (expression is Gcd) {
    return {
      'type': 'gcd',
      'args': expression.args.map(
        (term) => jsonifyExpression(term)
      ).toList(),
    };
  }
}
