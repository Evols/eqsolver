
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/trivializers/eliminate_eq_constant_factors_trivializer.dart';
import 'package:formula_transformator/core/trivializers/eliminate_eq_gcd_trivializer.dart';
import 'package:formula_transformator/core/trivializers/reorder_constant_trivializer.dart';

import 'constant_computation_trivializer.dart';
import 'empty_trivializer.dart';
import 'mult_one_trivializer.dart';
import 'mult_zero_trivializer.dart';
import 'nested_trivializer.dart';
import 'single_child_trivializer.dart';
import 'trivializer.dart';
import 'package:formula_transformator/core/utils.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

import 'add_zero_trivializer.dart';

const trivializers = <Trivializer>{
  AddZeroTrivializer(),
  MultOneTrivializer(),
  MultZeroTrivializer(),
  SingleChildTrivializer(),
  ConstantComputationTrivializer(),
  EmptyTrivializer(),
  NestedTrivializer(),
  EliminateEqGcdTrivializer(),
  EliminateEqConstantFactorsTrivializer(),
  ReorderConstantTrivializer(),
};

Expression applyTrivializers(Expression expression, [bool isEquation = false]) {
  var tempExpression = expression;
  var applied = true;
  while (applied) {
    applied = false;
    for (var trivializer in trivializers) {
      var transformed = mountExpressionAt(tempExpression, (elem, depth) => trivializer.transform(elem, depth == 0 && isEquation));
      if (transformed != null) {
        tempExpression = transformed;
        applied = true;
        break;
      }
    }
  }
  return tempExpression;
}

Equation applyTrivializersToEq(Equation equation) {
  return Equation(applyTrivializers(equation.leftPart), applyTrivializers(equation.rightPart));
}
