
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

class NestedTrivializer implements Trivializer {

  const NestedTrivializer();

  @override
  Value? transform(Value value) {
    if (value is Addition) {
      final additionChildren = value.children.whereType<Addition>();
      if (additionChildren.isNotEmpty) {
        return Addition([
          ...value.children.where((element) => !(element is Addition)),
          ...additionChildren.map((element) => element.children).expand((element) => element),
        ]);
      }
    }
    if (value is Multiplication) {
      final additionChildren = value.children.whereType<Multiplication>();
      if (additionChildren.isNotEmpty) {
        return Multiplication([
          ...value.children.where((element) => !(element is Multiplication)),
          ...additionChildren.map((element) => element.children).expand((element) => element),
        ]);
      }
    }
    return null;
  }

}
