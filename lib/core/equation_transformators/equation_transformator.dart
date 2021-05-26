
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/equation.dart';

abstract class EquationTransformator {

  List<Equation> transformEquation(Equation equation) {
    final res1 = transformEquationImpl(equation);
    if (res1.isNotEmpty) {
      return res1;
    }
    return transformEquationImpl(Equation(equation.rightPart, equation.leftPart));
  }

  @protected
  List<Equation> transformEquationImpl(Equation equation);
}
