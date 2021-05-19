
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

class ConstantComputationTrivializer implements Trivializer {

  const ConstantComputationTrivializer();

  @override
  Value? transform(Value value) {

    if (value is Addition) {
      final children = value.getChildren();
      final constants = children.whereType<Constant>();
      if (constants.length > 1) {
        final nonConstants = children.where((e) => !(e is Constant));
        final computationResult = constants.fold<double>(0.0, (value, element) => value + element.number);
        return Addition([ ...nonConstants, Constant(computationResult) ]);
      }
    }

    if (value is Multiplication) {
      final children = value.getChildren();
      final constants = children.whereType<Constant>();
      if (constants.length > 1) {
        final nonConstants = children.where((e) => !(e is Constant));
        final computationResult = constants.fold<double>(1.0, (value, element) => value * element.number);
        return Multiplication([ Constant(computationResult), ...nonConstants ]);
      }
    }

    return null;
  }

}
