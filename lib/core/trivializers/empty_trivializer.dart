
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

class EmptyTrivializer implements Trivializer {

  const EmptyTrivializer();

  @override
  Value? transform(Value value) {
    if (value is Addition) {
      if (value.children.isEmpty) {
        return Constant(0);
      }
    }
    if (value is Multiplication) {
      if (value.children.isEmpty) {
        return Constant(1);
      }
    }
    return null;
  }

}
