
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_solvers/solutions.dart';

abstract class EquationSolver {

  const EquationSolver();

  @nonVirtual
  Solutions solveEquation(Equation equation) {
    final resDirect = solveEquationImpl(equation);
    if (resDirect.constants.isNotEmpty || resDirect.variables.isNotEmpty) {
      return resDirect;
    }
    return solveEquationImpl(Equation(equation.rightPart, equation.leftPart));
  }

  @protected
  Solutions solveEquationImpl(Equation equation);
}
