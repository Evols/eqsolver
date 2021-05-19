
import 'package:formula_transformator/trivializers/trivializer.dart';
import 'package:formula_transformator/values/constant.dart';
import 'package:formula_transformator/values/multiplication.dart';
import 'package:formula_transformator/values/value.dart';

class MultOneTrivializer implements Trivializer {

  const MultOneTrivializer();

  @override
  Value? transform(Value value) {
    if (value is Multiplication) {
      final newChildren = value.children.where((child) => !(child is Constant && child.number == 1.0)).toList();
      if (newChildren.length != value.children.length) {
        return Multiplication(newChildren);
      }
    }
    return null;
  }

}
