
import 'package:flutter/cupertino.dart';
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/values/literal_constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

@immutable
class EliminateEqConstantFactorsTrivializer implements Trivializer {

  const EliminateEqConstantFactorsTrivializer();

  @override
  Value? transform(Value value, [bool isEquation = false]) {
    if (isEquation && value is Multiplication) {
      final newChildren = value.factors.where((element) => !(element is LiteralConstant)).toList();
      if (newChildren.length != value.factors.length) {
        return Multiplication(newChildren);
      }
    }
    return null;
  }

}
