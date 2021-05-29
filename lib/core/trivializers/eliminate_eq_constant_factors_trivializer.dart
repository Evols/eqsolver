
import 'package:flutter/cupertino.dart';
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

@immutable
class EliminateEqConstantFactorsTrivializer implements Trivializer {

  const EliminateEqConstantFactorsTrivializer();

  @override
  Expression? transform(Expression expression, [bool isEquation = false]) {
    if (isEquation && expression is Multiplication) {
      final newChildren = expression.factors.where((element) => !(element is LiteralConstant)).toList();
      if (newChildren.length != expression.factors.length) {
        return Multiplication(newChildren);
      }
    }
    return null;
  }

}
