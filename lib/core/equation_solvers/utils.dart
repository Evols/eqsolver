
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_solvers/ax_b_solver.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/core/expressions/utils.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:formula_transformator/extensions.dart';

Set<String> getVars(List<Expression> expressions) => expressions.flatMap(
  (part) => part.foldTree<Set<String>>(
    {},
    (accumulator, expression) => expression is Variable ? { ...accumulator, expression.name } : accumulator
  )
).toSet();

int getVarsCount(List<Expression> expressions) => getVars(expressions).length;

const solvers = <AxBEquationSolver>[
  AxBEquationSolver(),
];

Map<String, BigInt> trySolveEquation(Equation equation) => solvers.fold<Map<String, BigInt>>(
  {},
  (acc, elem) => acc.isEmpty ? elem.solveEquation(equation) : acc,
);

Map<String, BigInt> solveEquationSystem(List<Equation> equations, Map<String, BigInt> inSolutions) {

  var solutions = <String, BigInt>{ ...inSolutions };
  var solvedEquations = equations.map((equation) => injectVarSolutionsEquation(equation, solutions)).toList();
  var justChanged = true;
  while (justChanged) {
    final newSolutions = solvedEquations.flatMap(
      (equation) => trySolveEquation(equation).entries
    ).toList();
    justChanged = newSolutions.isNotEmpty;
    solutions.addAll(Map.fromEntries(newSolutions));
    solvedEquations = solvedEquations.map((equation) => injectVarSolutionsEquation(equation, solutions)).toList();
  }

  return solutions;

}
