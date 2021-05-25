
import 'package:formula_transformator/core/value_transformators/value_transformator.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

class InjectTransformator extends ValueTransformator {

  final Addition sourceEquation;
  final Value sourceExpression;
  final Value targetExpression;

  InjectTransformator(this.sourceEquation, this.sourceExpression, this.targetExpression);

  @override
  List<Value> transform(Value value) {

    if (!(value is Addition)) {
      return [];
    }

    // Source

    final sourceTermWithSourceExpression = sourceEquation.terms.firstWhere(
      (term) => identical(term, sourceExpression) || (term is Multiplication && term.factors.where(
        (factor) => identical(factor, sourceExpression)
      ).isNotEmpty),
    );

    final sourceTermsWithoutSourceExpression = sourceEquation.terms.where(
      (term) => !identical(term, sourceTermWithSourceExpression),
    ).toList();

    final sourceTermOtherFactors = (
      identical(sourceTermWithSourceExpression, sourceExpression)
      ? Constant(1)
      : Multiplication((sourceTermWithSourceExpression as Multiplication).factors.where(
        (factor) => !identical(factor, sourceExpression)
      ).toList())
    );

    // Target

    final targetTermWithSourceExpression = value.terms.firstWhere(
      (term) => identical(term, targetExpression) || (term is Multiplication && term.factors.where(
        (factor) => identical(factor, targetExpression)
      ).isNotEmpty),
    );

    final targetTermsWithoutSourceExpression = value.terms.where(
      (term) => !identical(term, targetTermWithSourceExpression),
    ).toList();

    final targetTermOtherFactors = (
      identical(targetTermWithSourceExpression, sourceExpression)
      ? Constant(1)
      : Multiplication((targetTermWithSourceExpression as Multiplication).factors.where(
        (factor) => !identical(factor, targetExpression)
      ).toList())
    );

    return [
      applyTrivializers(Addition([
        Multiplication([
          sourceTermOtherFactors,
          Addition(targetTermsWithoutSourceExpression),
        ]),
        Multiplication([
          Constant(-1),
          targetTermOtherFactors,
          Addition(sourceTermsWithoutSourceExpression),
        ]),
      ])),
    ];
  }

}
