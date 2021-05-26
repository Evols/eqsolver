
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

class ReorderConstantTrivializer implements Trivializer {

  const ReorderConstantTrivializer();

  @override
  Value? transform(Value value, [bool isEquation = false]) {
    if (value is Multiplication) {

      // Ensure there's exactly one constant factor
      final constants = value.factors.whereType<Constant>().toList();
      final constantsCount = constants.length;
      if (constantsCount != 1) {
        return null;
      }

      // Ensure the first term isn't a constant
      if (value.factors[0] is Constant) {
        return null;
      }

      final constantValue = constants[0];
      return Multiplication([
        constantValue,
        ...value.factors.where(
          (factor) => !(factor is Constant)
        ),
      ]);
    }
    return null;
  }

}
