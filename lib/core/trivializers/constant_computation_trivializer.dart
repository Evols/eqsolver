
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/literal_constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

class ConstantComputationTrivializer implements Trivializer {

  const ConstantComputationTrivializer();

  @override
  Value? transform(Value value, [bool isEquation = false]) {

    if (value is Addition) {
      final children = value.getChildren();
      final constants = children.whereType<LiteralConstant>();
      if (constants.length > 1) {
        final nonConstants = children.where((e) => !(e is LiteralConstant));
        final computationResult = constants.fold<BigInt>(BigInt.from(0), (value, element) => value + element.number);
        return Addition([ ...nonConstants, LiteralConstant(computationResult) ]);
      }
    }

    if (value is Multiplication) {
      final children = value.getChildren();
      final constants = children.whereType<LiteralConstant>();
      if (constants.length > 1) {
        final nonConstants = children.where((e) => !(e is LiteralConstant));
        final computationResult = constants.fold<BigInt>(BigInt.from(1), (value, element) => value * element.number);
        return Multiplication([ LiteralConstant(computationResult), ...nonConstants ]);
      }
    }

    return null;
  }

}
