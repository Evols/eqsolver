
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/expressions/gcd.dart';
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

@immutable
class ConstantComputationTrivializer implements Trivializer {

  const ConstantComputationTrivializer();

  @override
  Expression? transform(Expression expression, [bool isEquation = false]) {

    if (expression is Addition) {
      final children = expression.getChildren();
      final constants = children.whereType<LiteralConstant>();
      if (constants.length > 1) {
        final nonConstants = children.where((e) => !(e is LiteralConstant));
        final computationResult = constants.fold<BigInt>(BigInt.from(0), (expression, element) => expression + element.number);
        return Addition([ ...nonConstants, LiteralConstant(computationResult) ]);
      }
    }

    if (expression is Multiplication) {
      final children = expression.getChildren();
      final constants = children.whereType<LiteralConstant>();
      if (constants.length > 1) {
        final nonConstants = children.where((e) => !(e is LiteralConstant));
        final computationResult = constants.fold<BigInt>(BigInt.from(1), (expression, element) => expression * element.number);
        return Multiplication([ LiteralConstant(computationResult), ...nonConstants ]);
      }
    }

    if (expression is Gcd) {
      final children = expression.getChildren();
      final constants = children.whereType<LiteralConstant>();
      if (constants.length > 1) {
        final nonConstants = children.where((e) => !(e is LiteralConstant));
        final computationResult = constants.fold<BigInt>(BigInt.zero, (expression, element) => expression.gcd(element.number));
        return Gcd([ LiteralConstant(computationResult), ...nonConstants ]);
      }
    }

    return null;
  }

}
