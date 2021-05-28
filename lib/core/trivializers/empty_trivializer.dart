
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/literal_constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

@immutable
class EmptyTrivializer implements Trivializer {

  const EmptyTrivializer();

  @override
  Value? transform(Value value, [bool isEquation = false]) {
    if (value is Addition) {
      if (value.terms.isEmpty) {
        return LiteralConstant(BigInt.from(0));
      }
    }
    if (value is Multiplication) {
      if (value.factors.isEmpty) {
        return LiteralConstant(BigInt.from(1));
      }
    }
    return null;
  }

}
