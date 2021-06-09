
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_solvers/equation_solver.dart';
import 'package:formula_transformator/core/equation_solvers/solutions.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/named_constant.dart';
import 'package:formula_transformator/utils.dart';

class BezoutEquationSolver extends EquationSolver {

  const BezoutEquationSolver();

  Solutions solveEquationImpl(Equation equation) {

    final leftPart = equation.leftPart;
    if (!(leftPart is Addition) || leftPart.terms.length != 2) {
      return Solutions();
    }

    final firstTerm = leftPart.terms[0];
    final secondTerm = leftPart.terms[1];
    if (!(firstTerm is Multiplication) || !(secondTerm is Multiplication)) {
      return Solutions();
    }

    final firstTermLiteralConstant = firstTerm.factors.fold<BigInt>(
      BigInt.from(1),
      (previousValue, element) => element is LiteralConstant ? previousValue * element.number : previousValue,
    );
    final secondTermLiteralConstant = secondTerm.factors.fold<BigInt>(
      BigInt.from(1),
      (previousValue, element) => element is LiteralConstant ? previousValue * element.number : previousValue,
    );

    if (firstTermLiteralConstant.abs() <= BigInt.one || secondTermLiteralConstant.abs() <= BigInt.one) {
      return Solutions();
    }

    final firstTermNonLiteralConstants = firstTerm.factors.where(
      (factor) => !(factor is LiteralConstant)
    ).toList();
    final secondTermNonLiteralConstants = secondTerm.factors.where(
      (factor) => !(factor is LiteralConstant)
    ).toList();

    if (firstTermNonLiteralConstants.length != 1 || secondTermNonLiteralConstants.length != 1) {
      return Solutions();
    }

    final firstTermNamedConstant = firstTermNonLiteralConstants.first;
    final secondTermNamedConstant = secondTermNonLiteralConstants.first;

    if (!(firstTermNamedConstant is NamedConstant) || !(secondTermNamedConstant is NamedConstant)) {
      return Solutions();
    }

    final rightPart = equation.rightPart;
    if (!(rightPart is LiteralConstant)) {
      return Solutions();
    }

    final u0 = Ref<BigInt>(BigInt.zero);
    final v0 = Ref<BigInt>(BigInt.zero);
    final gcd = extEuclidAlgo(firstTermLiteralConstant, secondTermLiteralConstant, u0, v0);

    if (rightPart.number % gcd != BigInt.zero) {
      return Solutions();
    }

    final scaleFactor = rightPart.number ~/ gcd;

    return Solutions({
      firstTermNamedConstant.name: u0.value * scaleFactor,
      secondTermNamedConstant.name: v0.value * scaleFactor,
    }, {});
  }
}
