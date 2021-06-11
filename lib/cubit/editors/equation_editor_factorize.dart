
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/expression_transformators/factorize_transformator.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/cubit/equation_editor_cubit.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/utils.dart';
import 'package:formula_transformator/extensions.dart';
import 'package:tuple/tuple.dart';

enum FactorizeStep { SelectFactor, SelectTerms, Finished }

@immutable
class EquationEditorFactorize extends EquationEditorEditing {

  final FactorizeStep step;
  final List<Expression> selectedFactors;
  final List<Expression> selectedTerms;

  EquationEditorFactorize(this.step, { this.selectedTerms = const [], this.selectedFactors = const [] });

  @override
  String getStepName() {
    switch (step) {
      case FactorizeStep.SelectFactor: return 'Select the common factor in one of the terms to factor';
      case FactorizeStep.SelectTerms: return 'Select the terms to factor';
      default: return '';
    }
  }

  @override
  bool hasFinished() => step == FactorizeStep.Finished;

  static Expression? getCommonFactor(Expression v1, Expression v2) {
    if (v1 is LiteralConstant && v2 is LiteralConstant) {
      final gcd = v1.number.gcd(v2.number);
      if (gcd != BigInt.from(1)) {
        return LiteralConstant(gcd);
      }
    }
    return v1.isEquivalentTo(v2) ? v1 : null;
  }

  static List<Tuple2<Expression, int>> computeCardinality(List<Expression> expressions) {
    var cardinalityList = <Tuple2<Expression, int>?>[];
    for (var elem in expressions) {
      final firstWhere = cardinalityList.firstWhere(
        (cardinalityElem) => cardinalityElem!.item1 == elem,
        orElse: () => null,
      );
      if (firstWhere == null) {
        cardinalityList.add(Tuple2(elem, 1));
      } else {
        final newCardinality = firstWhere.item2 + 1;
        cardinalityList.remove(firstWhere);
        cardinalityList.add(Tuple2(firstWhere.item1, newCardinality));
      }
    }
    return cardinalityList.map((element) => element!).toList();
  }

  static List<Expression> getCommonFactors(List<List<Expression>> termsFactors) {

    // Not good for cache

    final constantPartTerm = termsFactors.map((term) => term.fold<BigInt>(
      BigInt.one,
      (factorProduct, factor) => factor is LiteralConstant ? factorProduct * factor.number : factorProduct,
    ));

    final constantCommonFactorAbs = constantPartTerm.fold<BigInt>(
      BigInt.zero,
      (commonFactor, term) => term.abs().gcd(commonFactor),
    );

    final negativeCommonFactor = constantPartTerm.where(
      (term) => term >= BigInt.zero,
    ).isEmpty ? -BigInt.one : BigInt.one;

    final constantCommonFactor = constantCommonFactorAbs * negativeCommonFactor;

    final termsCardinalityMap = termsFactors.map(
      (term) => term.where((factor) => !(factor is LiteralConstant)).toList()
    ).map(
      (term) => computeCardinality(term)
    ).toList();

    final commonFactors = termsCardinalityMap.fold<List<Tuple2<Expression, int>>>(
      termsCardinalityMap[0],
      (commonFactors, term) => commonFactors.map(
        (commonFactor) => Tuple2<Expression, int>(
          commonFactor.item1,
          min(
            commonFactor.item2,
            term.firstWhere(
              (termFactor) => termFactor.item1 == commonFactor.item1,
              orElse: () => Tuple2<Expression, int>(LiteralConstant(BigInt.one), 0),
            ).item2,
          ),
        )
      ).toList()
    );

    return [
      ...(constantCommonFactor != BigInt.one ? [LiteralConstant(constantCommonFactor)] : []),
      ...commonFactors.flatMap<Expression>(
        (element) => List.filled(element.item2, element.item1),
      ).toList(),
    ];
  }

  static bool hasAllFactors(List<Expression> factorsToLookFor, List<Expression> inMultiplication) {

    var factorsToLookForCopy = [...factorsToLookFor];
    var inMultiplicationCopy = [...inMultiplication];

    for (var factorsIndex = factorsToLookForCopy.length - 1; factorsIndex >= 0; factorsIndex--) {
      for (var multiplicationIndex = inMultiplicationCopy.length - 1; multiplicationIndex >= 0; multiplicationIndex--) {
        final commonFactor = getCommonFactor(factorsToLookForCopy[factorsIndex], inMultiplicationCopy[multiplicationIndex]);
        if (commonFactor != null) {
          factorsToLookForCopy.removeAt(factorsIndex);
          inMultiplicationCopy.removeAt(multiplicationIndex);
          break;
        }
      }
    }

    return factorsToLookForCopy.isEmpty;
  }

  @override
  Selectable isSelectable(Equation equation, Expression expression) {
    switch (step) {
    case FactorizeStep.SelectFactor:
      if (
        equation.findTree(
          (additionCandidate) => additionCandidate is Addition
          // Check that the addition has a multiplication term, and that this multiplication term has expression as one of its factors
          && additionCandidate.terms.where(
            (multiplicateCandidate) => multiplicateCandidate is Multiplication
            // Multiplication term has expression as one of its factors
            && multiplicateCandidate.factors.where(
              (factor) => identical(factor, expression)
            ).isNotEmpty
            // Multiplication term has the selected factors
            && multiplicateCandidate.factors.where(
              (factor) => selectedFactors.where((selectedFactor) => identical(selectedFactor, factor)).isNotEmpty
            ).length == selectedFactors.length
          ).isNotEmpty
          // Check that the addition has another multiplication term, and that this other multiplication term has is divisible by the selected factors and the new factor
          && additionCandidate.terms.where(
            (otherMultiplicateCandidate) => otherMultiplicateCandidate is Multiplication
            // Not the multiplication that contains expression
            && otherMultiplicateCandidate.factors.where(
              (factor) => identical(factor, expression)
            ).isEmpty
            // Divisible by the selected factors and the new factor
            && hasAllFactors(
              selectedFactors.where(
                (selectedFactor) => identical(selectedFactor, expression)
              ).isNotEmpty ? selectedFactors : [ ...selectedFactors, expression ],
              otherMultiplicateCandidate.factors,
            )
          ).isNotEmpty
        ) != null
      ) {
        return (
          selectedFactors.where((e) => identical(e, expression)).isNotEmpty
          ? Selectable.MultipleSelected
          : Selectable.MultipleEmpty
        );
      }
      return Selectable.None;

    case FactorizeStep.SelectTerms:
      if (
        equation.findTree(
          (additionCandidate) => additionCandidate is Addition
          // Check that the addition has a multiplication term, and that this multiplication term has expression as one of its factors
          && additionCandidate.terms.where(
            (multiplicateCandidate) => multiplicateCandidate is Multiplication
            // Multiplication term has expression as one of its factors
            && identical(multiplicateCandidate, expression)
            // Divisible by the selected factors and the new factor
            && hasAllFactors(selectedFactors, multiplicateCandidate.factors)
          ).isNotEmpty
          // Check that the addition has another multiplication term, and that this other multiplication term has is divisible by the selected factors and the new factor
          && additionCandidate.terms.where(
            (multiplicateCandidate) => multiplicateCandidate is Multiplication
            // Multiplication term has the selected factors
            && multiplicateCandidate.factors.where(
              (factor) => selectedFactors.where((selectedFactor) => identical(selectedFactor, factor)).isNotEmpty
            ).length == selectedFactors.length
          ).isNotEmpty
        ) != null
      ) {
        return (
          selectedTerms.where((e) => identical(e, expression)).isNotEmpty
          ? Selectable.MultipleSelected
          : Selectable.MultipleEmpty
        );
      }
      return Selectable.None;
    default:
      return Selectable.None;
    }
  }

  @override
  bool canValidate() {
    switch (step) {
    case FactorizeStep.SelectFactor:
      return selectedFactors.length > 0;
    case FactorizeStep.SelectTerms:
      return selectedTerms.length > 1;
    default:
      return true;
    }
  }

  @override
  EquationEditorState nextStep(EquationsCubit equationsCubit) {
    final newStep = FactorizeStep.values[step.index + 1];
    if (newStep == FactorizeStep.Finished) {

      for (var equation in equationsCubit.state.equations) {

        final addition = equation.findTree(
          (additionCandidate) => additionCandidate is Addition
          && additionCandidate.terms.where(
            (multiplicateCandidate) => multiplicateCandidate is Multiplication
            // Multiplication term has the selected factors
            && multiplicateCandidate.factors.where(
              (factor) => selectedFactors.where((selectedFactor) => identical(selectedFactor, factor)).isNotEmpty
            ).length == selectedFactors.length
          ).isNotEmpty
        );

        if (addition != null) {
          equationsCubit.addEquations(
            FactorizeTransformator(selectedFactors, selectedTerms).transformExpression(addition).map(
              (transformed) => equation.mountAt(addition, transformed)
            ).toList()
          );
        }

      }

      return EquationEditorIdle();
    }
    return EquationEditorFactorize(
      newStep,
      selectedFactors: selectedFactors,
      selectedTerms: selectedTerms,
    );
  }

  @override
  EquationEditorEditing onSelect(Equation equation, Expression expression) {
    switch (step) {
    case FactorizeStep.SelectFactor:
      return EquationEditorFactorize(
        step,
        selectedFactors: flipExistenceArray<Expression>(selectedFactors, expression),
        selectedTerms: selectedTerms,
      );
    case FactorizeStep.SelectTerms:
      return EquationEditorFactorize(
        step,
        selectedFactors: selectedFactors,
        selectedTerms: flipExistenceArray<Expression>(selectedTerms, expression),
      );
    default:
      return this;
    }
  }

}
