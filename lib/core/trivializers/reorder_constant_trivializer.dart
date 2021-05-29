
import 'package:flutter/cupertino.dart';
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/named_constant.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/extensions.dart';

@immutable
class ReorderConstantTrivializer implements Trivializer {

  const ReorderConstantTrivializer();

  @override
  Expression? transform(Expression expression, [bool isEquation = false]) {
    if (expression is Multiplication) {

      final sortedFactors = [...expression.factors];
      sortedFactors.sort((v1, v2) {
        final order1 = v1 is LiteralConstant ? 0 : v1 is NamedConstant ? 1 : 2;
        final order2 = v2 is LiteralConstant ? 0 : v2 is NamedConstant ? 1 : 2;
        return order1.compareTo(order2);
      });

      if (sortedFactors.whereIndexed(
        (sortedFactor, index) => !identical(sortedFactor, expression.factors[index])
      ).isEmpty) {
        return null;
      }

      return Multiplication(sortedFactors);

    }
    return null;
  }

}
