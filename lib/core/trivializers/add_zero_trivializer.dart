
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/literal_constant.dart';
import 'package:formula_transformator/core/values/value.dart';

class AddZeroTrivializer implements Trivializer {

  const AddZeroTrivializer();

  @override
  Value? transform(Value value, [bool isEquation = false]) {
    if (value is Addition) {
      final newChildren = value.terms.where((child) => !(child is LiteralConstant && child.number == BigInt.from(0))).toList();
      if (newChildren.length != value.terms.length) {
        return Addition(newChildren);
      }
    }
    return null;
  }

}
