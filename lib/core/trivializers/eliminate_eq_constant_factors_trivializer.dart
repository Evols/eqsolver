
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

class EliminateEqConstantFactorsTrivializer implements Trivializer {

  const EliminateEqConstantFactorsTrivializer();

  @override
  Value? transform(Value value, [bool isEquation = false]) {
    if (isEquation && value is Multiplication) {
      final newChildren = value.factors.where((element) => !(element is Constant)).toList();
      if (newChildren.length != value.factors.length) {
        return Multiplication(newChildren);
      }
    }
    return null;
  }

}
