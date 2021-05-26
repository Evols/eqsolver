
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_transformators/equation_transformator.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

class InjectTransformator extends EquationTransformator {

  final Equation sourceEquation;
  final Value sourceExpression;
  final Value targetExpression;

  InjectTransformator(this.sourceEquation, this.sourceExpression, this.targetExpression);

  List<Equation> tryWithSourceEquation(Equation sourceEquation, Equation targetEquation) {

    // a*x=b ; c*x=d
    // => x=b/a; c*b/a=d ; c*b=a*d

    final sourceLhs = sourceEquation.leftPart;
    final sourceRhs = sourceEquation.rightPart;

    final targetLhs = targetEquation.leftPart;
    final targetRhs = targetEquation.rightPart;

    // Ensure the equation is the right one

    final sourceLhsHasExpression = identical(sourceLhs, sourceExpression) || (sourceLhs is Multiplication && sourceLhs.factors.where(
      (factor) => identical(factor, sourceExpression)
    ).isNotEmpty);

    final targetLhsHasExpression = identical(targetLhs, targetExpression) || (targetLhs is Multiplication && targetLhs.factors.where(
      (factor) => identical(factor, targetExpression)
    ).isNotEmpty);

    if (!sourceLhsHasExpression || !targetLhsHasExpression) {
      return [];
    }

    final sourceLhsWithoutExpression = (
      sourceLhs is Multiplication 
      ? Multiplication(
        sourceLhs.factors.where(
          (factor) => identical(factor, sourceExpression)
        ).toList()
      )
      : Constant(1)
    );

    final targetLhsWithoutExpression = (
      targetLhs is Multiplication 
      ? Multiplication(
        targetLhs.factors.where(
          (factor) => identical(factor, targetExpression)
        ).toList()
      )
      : Constant(1)
    );

    return [
      Equation(
        Multiplication([
          sourceLhsWithoutExpression,
          targetRhs,
        ]),
        Multiplication([
          targetLhsWithoutExpression,
          sourceRhs,
        ])
      ),
    ];
  }

  @override
  List<Equation> transformEquationImpl(Equation equation) {
    final res1 = tryWithSourceEquation(sourceEquation, equation);
    if (res1.isNotEmpty) {
      return res1;
    }
    return tryWithSourceEquation(Equation(sourceEquation.rightPart, sourceEquation.leftPart), equation);
  }

}
