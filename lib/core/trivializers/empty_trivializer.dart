
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

@immutable
class EmptyTrivializer implements Trivializer {

  const EmptyTrivializer();

  @override
  Expression? transform(Expression expression, [bool isEquation = false]) {
    if (expression is Addition) {
      if (expression.terms.isEmpty) {
        return LiteralConstant(BigInt.from(0));
      }
    }
    if (expression is Multiplication) {
      if (expression.factors.isEmpty) {
        return LiteralConstant(BigInt.from(1));
      }
    }
    return null;
  }

}
