
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

Expression parseExpression(dynamic json) {
  if (json is Map<String, dynamic>) {
    final type = json["type"];
    if (type == 'named_constant') {
      final name = json["name"] as String;
      return NamedConstant(name);
    }
    else if (type == 'literal_constant') {
      final numberString = json["number"] as String;
      final number = BigInt.tryParse(numberString)!;
      return LiteralConstant(number);
    }
    else if (type == 'variable') {
      final name = json["name"] as String;
      return Variable(name);
    }
    else if (type == 'addition') {
      final terms = json["terms"] as List<dynamic>;
      return Addition(terms.map(
        (term) => parseExpression(term)
      ).whereType<Expression>().toList());
    }
    else if (type == 'multiplication') {
      final factors = json["factors"] as List<dynamic>;
      return Multiplication(factors.map(
        (factor) => parseExpression(factor)
      ).whereType<Expression>().toList());
    }
    else if (type == 'gcd') {
      final args = json["args"] as List<dynamic>;
      return Gcd(args.map(
        (arg) => parseExpression(arg)
      ).whereType<Expression>().toList());
    }
  }

  throw Exception('Unknown expression type for $json');
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
      'number': expression.number.toString(),
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
      'factors': expression.factors.map(
        (factor) => jsonifyExpression(factor)
      ).toList(),
    };
  }
  if (expression is Gcd) {
    return {
      'type': 'gcd',
      'args': expression.args.map(
        (arg) => jsonifyExpression(arg)
      ).toList(),
    };
  }
}
