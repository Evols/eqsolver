
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/expressions/gcd.dart';
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

@immutable
class SingleChildTrivializer implements Trivializer {

  const SingleChildTrivializer();

  @override
  Expression? transform(Expression expression, [bool isEquation = false]) {
    if (expression is Addition || expression is Multiplication || expression is Gcd) {
      final children = expression.getChildren();
      if (children.length == 1) {
        return children[0];
      }
    }
    return null;
  }

}
