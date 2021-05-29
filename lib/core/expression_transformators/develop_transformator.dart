
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/expression_transformators/expression_transformator.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

@immutable
class DevelopTransformator extends ExpressionTransformator {

  final List<Expression> termsToDevelop;

  DevelopTransformator(this.termsToDevelop);

  @override
  List<Expression> transformExpression(Expression expression) {

    if (!(expression is Multiplication) || expression.factors.length < 2) {
      return [];
    }

    final additions = expression.factors.where(
      (factor) => factor is Addition && factor.terms.where(
        (term) => termsToDevelop.where(
          (term2) => identical(term, term2)
        ).isNotEmpty
      ).length == termsToDevelop.length
    ).toList();

    if (additions.isEmpty) {
      return [];
    }

    final addition = additions[0];
    final otherFactors = expression.factors.where((element) => !identical(element, addition)).toList();

    final termsToNotDevelop = addition.getChildren().where(
      (term) => termsToDevelop.where(
        (termToDevelop) => identical(term, termToDevelop)
      ).isEmpty
    ).toList();

    return [
      applyTrivializers(Addition([
        ...termsToDevelop.map((termToDevelop) => Multiplication([
          ...otherFactors,
          termToDevelop,
        ])).toList(),
        Multiplication([
          ...otherFactors,
          Addition(termsToNotDevelop),
        ]),
      ])),
    ];
  }

}
