
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_transformators/equation_transformator.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/literal_constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

@immutable
class ReorganizeTransformator extends EquationTransformator {

  final List<Value> selectedTerms;

  ReorganizeTransformator(this.selectedTerms);

  Value buildSide(Value thisPart, Value otherPart) => Addition([
    // thisPart's values that aren't selected
    ...(thisPart is Addition ? thisPart.terms : [thisPart]).where(
      (term) => selectedTerms.where(
        (selectedTerm) => identical(term, selectedTerm)
      ).isEmpty
    ).toList(),
    // otherPart's values that are selected, and then we negate them
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
