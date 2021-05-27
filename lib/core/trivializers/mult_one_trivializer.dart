
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/values/literal_constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

class MultOneTrivializer implements Trivializer {

  const MultOneTrivializer();

  @override
  Value? transform(Value value, [bool isEquation = false]) {
    if (value is Multiplication) {
      final newChildren = value.factors.where((child) => !(child is LiteralConstant && child.number == BigInt.from(1))).toList();
      if (newChildren.length != value.factors.length) {
        return Multiplication(newChildren);
      }
    }
    return null;
  }

}
