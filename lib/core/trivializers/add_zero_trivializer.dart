
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

@immutable
class AddZeroTrivializer implements Trivializer {

  const AddZeroTrivializer();

  @override
  Expression? transform(Expression expression, [bool isEquation = false]) {
    if (expression is Addition) {
      final newChildren = expression.terms.where((child) => !(child is LiteralConstant && child.number == BigInt.from(0))).toList();
      if (newChildren.length != expression.terms.length) {
        return Addition(newChildren);
      }
    }
    return null;
  }

}
