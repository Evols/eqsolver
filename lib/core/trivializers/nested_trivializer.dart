
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

class NestedTrivializer implements Trivializer {

  const NestedTrivializer();

  @override
  Value? transform(Value value, [bool isEquation = false]) {
    if (value is Addition) {
      final additionChildren = value.terms.whereType<Addition>();
      if (additionChildren.isNotEmpty) {
        return Addition([
          ...value.terms.where((element) => !(element is Addition)),
          ...additionChildren.map((element) => element.terms).expand((element) => element),
        ]);
      }
    }
    if (value is Multiplication) {
      final additionChildren = value.factors.whereType<Multiplication>();
      if (additionChildren.isNotEmpty) {
        return Multiplication([
          ...value.factors.where((element) => !(element is Multiplication)),
          ...additionChildren.map((element) => element.factors).expand((element) => element),
        ]);
      }
    }
    return null;
  }

}
