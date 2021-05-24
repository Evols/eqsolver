
import 'package:formula_transformator/core/trivializers/eliminate_eq_constant_factors_trivializer.dart';
import 'package:formula_transformator/core/trivializers/eliminate_eq_gcd_trivializer.dart';

import 'constant_computation_trivializer.dart';
import 'empty_trivializer.dart';
import 'mult_one_trivializer.dart';
import 'mult_zero_trivializer.dart';
import 'nested_trivializer.dart';
import 'single_child_trivializer.dart';
import 'trivializer.dart';
import 'package:formula_transformator/core/utils.dart';
import 'package:formula_transformator/core/values/value.dart';

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
};

Value applyTrivializers(Value value, [bool isEquation = false]) {
  var tempValue = value;
  var applied = true;
  while (applied) {
    applied = false;
    for (var trivializer in trivializers) {
      var transformed = mountValueAt(tempValue, (elem, depth) => trivializer.transform(elem, depth == 0 && isEquation));
      if (transformed != null) {
        tempValue = transformed;
        applied = true;
        break;
      }
    }
  }
  return tempValue;
}
