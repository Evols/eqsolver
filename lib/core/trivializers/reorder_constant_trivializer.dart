
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/values/literal_constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/named_constant.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/extensions.dart';

class ReorderConstantTrivializer implements Trivializer {

  const ReorderConstantTrivializer();

  @override
  Value? transform(Value value, [bool isEquation = false]) {
    if (value is Multiplication) {

      final sortedFactors = [...value.factors];
      sortedFactors.sort((v1, v2) {
        final order1 = v1 is LiteralConstant ? 0 : v1 is NamedConstant ? 1 : 2;
        final order2 = v2 is LiteralConstant ? 0 : v2 is NamedConstant ? 1 : 2;
        return order1.compareTo(order2);
      });

      if (sortedFactors.whereIndexed(
        (sortedFactor, index) => !identical(sortedFactor, value.factors[index])
      ).isEmpty) {
        return null;
      }

      return Multiplication(sortedFactors);

    }
    return null;
  }

}
