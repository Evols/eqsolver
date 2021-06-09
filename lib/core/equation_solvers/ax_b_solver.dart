
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_solvers/equation_solver.dart';
import 'package:formula_transformator/core/equation_solvers/solutions.dart';
import 'package:formula_transformator/core/equation_solvers/utils.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';

class AxBEquationSolver extends EquationSolver{

  const AxBEquationSolver();

  Solutions solveEquationImpl(Equation equation) {
    if (getVarsCount(equation.parts) != 1) {
      return Solutions();
    }

    final asSinglePart = applyTrivializers(Addition([
      equation.rightPart,
      Multiplication([
        LiteralConstant(BigInt.from(-1)),
        equation.leftPart,
      ]),
    ]));

    var constantTermSum = BigInt.zero;
    Expression? nonConstantTerm;
    if (asSinglePart is Addition) {
      for (var term in asSinglePart.terms) {
        if (term is LiteralConstant) {
          constantTermSum += term.number;
        } else if ((term is Multiplication || term is Variable) && nonConstantTerm == null) {
          nonConstantTerm = term;
        } else {
          return Solutions();
        }
      }
    } else if (asSinglePart is Multiplication || asSinglePart is Variable) {
      nonConstantTerm = asSinglePart;
    }

    if (nonConstantTerm == null) {
      return Solutions();
    }

    var constantFactorProduct = BigInt.one;
    Variable? nonConstantFactor;
    if (nonConstantTerm is Multiplication) {
      for (var factor in nonConstantTerm.factors) {
        if (factor is LiteralConstant) {
          constantFactorProduct *= factor.number;
        } else if ((factor is Variable) && nonConstantFactor == null) {
          nonConstantFactor = factor;
        } else {
          return Solutions();
        }
      }
    }

    if (nonConstantFactor == null) {
      return Solutions();
    }

    if (constantTermSum % constantFactorProduct != BigInt.zero) {
      return Solutions();
    }

    return Solutions({}, { nonConstantFactor.name: (-constantTermSum ~/ constantFactorProduct) });
  }
}
