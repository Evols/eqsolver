
import 'package:formula_transformator/core/transformators/transformator.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

class InjectTransformator extends Transformator {

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

    final sourceTermWithSourceExpression = sourceEquation.children.firstWhere(
      (term) => identical(term, sourceExpression) || (term is Multiplication && term.children.where(
        (factor) => identical(factor, sourceExpression)
      ).isNotEmpty),
    );

    final sourceTermsWithoutSourceExpression = sourceEquation.children.where(
      (term) => !identical(term, sourceTermWithSourceExpression),
    ).toList();

    final sourceTermOtherFactors = (
      identical(sourceTermWithSourceExpression, sourceExpression)
      ? Constant(1)
      : Multiplication((sourceTermWithSourceExpression as Multiplication).children.where(
        (factor) => !identical(factor, sourceExpression)
      ).toList())
    );

    // Target

    final targetTermWithSourceExpression = value.children.firstWhere(
      (term) => identical(term, targetExpression) || (term is Multiplication && term.children.where(
        (factor) => identical(factor, targetExpression)
      ).isNotEmpty),
    );

    final targetTermsWithoutSourceExpression = value.children.where(
      (term) => !identical(term, targetTermWithSourceExpression),
    ).toList();

    final targetTermOtherFactors = (
      identical(targetTermWithSourceExpression, sourceExpression)
      ? Constant(1)
      : Multiplication((targetTermWithSourceExpression as Multiplication).children.where(
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
