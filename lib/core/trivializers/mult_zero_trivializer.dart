
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/values/literal_constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

@immutable
class MultZeroTrivializer implements Trivializer {

  const MultZeroTrivializer();

  @override
  Value? transform(Value value, [bool isEquation = false]) {
    if (value is Multiplication) {
      final newChildren = value.factors.where((child) => child is LiteralConstant && child.number == BigInt.from(0));
      if (newChildren.isNotEmpty) {
        return LiteralConstant(BigInt.from(0));
      }
    }
    return null;
  }

}
