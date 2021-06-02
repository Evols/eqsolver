
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/core/expressions/variable.dart';

int getExpressionClassId(Expression val) {
  if (val is LiteralConstant) {
    return 1;
  }
  if (val is Variable) {
    return 2;
  }
  if (val is Addition) {
    return 3;
  }
  if (val is Multiplication) {
    return 4;
  }
  return 0;
}

Expression injectVarSolutionsExpression(Expression expression, Map<String, BigInt> solutions) => expression.mountWithGenerator(
  (expression) => (
    (expression is Variable && solutions.containsKey(expression.name)) 
    ? LiteralConstant(solutions[expression.name]!)
    : null
  )
);


Equation injectVarSolutionsEquation(Equation equation, Map<String, BigInt> solutions) => Equation.fromParts(equation.parts.map(
  (part) => injectVarSolutionsExpression(part, solutions)
).toList());
