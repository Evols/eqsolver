
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/equation.dart';

abstract class EquationSolver {

  @nonVirtual
  Equation? solveEquation(Equation equation) => solveEquationImpl(equation) ?? solveEquationImpl(Equation(equation.rightPart, equation.leftPart));

  @protected
  Equation? solveEquationImpl(Equation equation);
}
