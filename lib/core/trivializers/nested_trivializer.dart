
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

@immutable
class NestedTrivializer implements Trivializer {

  const NestedTrivializer();

  @override
  Expression? transform(Expression expression, [bool isEquation = false]) {
    if (expression is Addition) {
      final additionChildren = expression.terms.whereType<Addition>();
      if (additionChildren.isNotEmpty) {
        return Addition([
          ...expression.terms.where((element) => !(element is Addition)),
          ...additionChildren.map((element) => element.terms).expand((element) => element),
        ]);
      }
    }
    if (expression is Multiplication) {
      final additionChildren = expression.factors.whereType<Multiplication>();
      if (additionChildren.isNotEmpty) {
        return Multiplication([
          ...expression.factors.where((element) => !(element is Multiplication)),
          ...additionChildren.map((element) => element.factors).expand((element) => element),
        ]);
      }
    }
    return null;
  }

}
