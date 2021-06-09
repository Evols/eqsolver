
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_solvers/ax_b_solver.dart';
import 'package:formula_transformator/core/equation_solvers/bezout_solver.dart';
import 'package:formula_transformator/core/equation_solvers/equation_solver.dart';
import 'package:formula_transformator/core/equation_solvers/solutions.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/named_constant.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:formula_transformator/extensions.dart';

Set<String> getVariables(List<Expression> expressions) => expressions.flatMap(
  (part) => part.foldTree<Set<String>>(
    {},
    (accumulator, expression) => expression is Variable ? { ...accumulator, expression.name } : accumulator
  )
).toSet();

Set<String> getNamedConstants(List<Expression> expressions) => expressions.flatMap(
  (part) => part.foldTree<Set<String>>(
    {},
    (accumulator, expression) => expression is NamedConstant ? { ...accumulator, expression.name } : accumulator
  )
).toSet();

int getVarsCount(List<Expression> expressions) => getVariables(expressions).length;
int getUnsolvedCount(List<Expression> expressions) => getVariables(expressions).length + getNamedConstants(expressions).length;

const solvers = <EquationSolver>[
  AxBEquationSolver(),
  BezoutEquationSolver(),
];

Solutions trySolveEquation(Equation equation) => solvers.fold<Solutions>(
  Solutions(),
  (acc, elem) => (acc.constants.isEmpty && acc.variables.isEmpty) ? elem.solveEquation(equation) : acc,
);

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

Expression injectConstValuesExpression(Expression expression, Map<String, BigInt> values) => expression.mountWithGenerator(
  (expression) => (
    (expression is NamedConstant && values.containsKey(expression.name)) 
    ? LiteralConstant(values[expression.name]!)
    : null
  )
);

Equation injectConstValuesEquation(Equation equation, Map<String, BigInt> values) => Equation.fromParts(equation.parts.map(
  (part) => injectConstValuesExpression(part, values)
).toList());

Equation injectSolutionsEquation(Equation equation, Solutions solutions) => Equation.fromParts(equation.parts.map(
  (part) => injectVarSolutionsExpression(injectConstValuesExpression(part, solutions.constants), solutions.variables)
).toList());

Solutions solveEquationSystem(List<Equation> equations, Solutions inSolutions) {

  var solutions = inSolutions.copy();
  var solvedEquations = equations.map((equation) => injectSolutionsEquation(equation, solutions)).toList();
  var justChanged = true;
  while (justChanged) {
    final newSolutions = solvedEquations.map(
      (equation) => trySolveEquation(equation)
    ).toList();
    final newSolution = Solutions.fromArray(newSolutions);
    justChanged = newSolution.constants.isNotEmpty || newSolution.variables.isNotEmpty;
    solutions = Solutions.fromArray([ solutions, ...newSolutions ]);
    solvedEquations = solvedEquations.map((equation) => injectSolutionsEquation(equation, solutions)).toList();
  }

  print('solvedEquations: $solvedEquations');

  return solutions;

}
