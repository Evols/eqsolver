
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/equation.dart';

abstract class EquationSolver {

  const EquationSolver();

  @nonVirtual
  Map<String, BigInt> solveEquation(Equation equation) {
    final resDirect = solveEquationImpl(equation);
    if (resDirect.isNotEmpty) {
      return resDirect;
    }
    return solveEquationImpl(Equation(equation.rightPart, equation.leftPart));
  }

  @protected
  Map<String, BigInt> solveEquationImpl(Equation equation);
}
