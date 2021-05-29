
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

@immutable
class MultOneTrivializer implements Trivializer {

  const MultOneTrivializer();

  @override
  Expression? transform(Expression expression, [bool isEquation = false]) {
    if (expression is Multiplication) {
      final newChildren = expression.factors.where((child) => !(child is LiteralConstant && child.number == BigInt.from(1))).toList();
      if (newChildren.length != expression.factors.length) {
        return Multiplication(newChildren);
      }
    }
    return null;
  }

}
