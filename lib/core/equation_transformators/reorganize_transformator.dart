
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_transformators/equation_transformator.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

@immutable
class ReorganizeTransformator extends EquationTransformator {

  final List<Expression> selectedTerms;

  ReorganizeTransformator(this.selectedTerms);

  Expression buildSide(Expression thisPart, Expression otherPart) => Addition([
    // thisPart's expressions that aren't selected
    ...(thisPart is Addition ? thisPart.terms : [thisPart]).where(
      (term) => selectedTerms.where(
        (selectedTerm) => identical(term, selectedTerm)
      ).isEmpty
    ).toList(),
    // otherPart's expressions that are selected, and then we negate them
    ...(otherPart is Addition ? otherPart.terms : [otherPart]).where(
      (term) => selectedTerms.where(
        (selectedTerm) => identical(term, selectedTerm)
      ).isNotEmpty
    ).map(
      (term) => Multiplication([
        LiteralConstant(BigInt.from(-1)),
        term,
      ])
    ).toList(),
  ]);

  @override
  List<Equation> transformEquationImpl(Equation equation) {
    return [
      Equation(
        buildSide(equation.leftPart, equation.rightPart),
        buildSide(equation.rightPart, equation.leftPart),
      ),
    ];
  }

}
