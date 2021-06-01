
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_transformators/delta_2nd_deg_transformator.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/cubit/equation_editor_cubit.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';

enum Delta2ndDegStep { SelectVar, Finished }

@immutable
class EquationEditorDelta2ndDeg extends EquationEditorEditing {

  final Delta2ndDegStep step;
  final Equation? selectedEquation;
  final String? selectedVarId;

  EquationEditorDelta2ndDeg(this.step, { this.selectedEquation, this.selectedVarId, });

  @override
  String getStepName() {
    switch (step) {
      case Delta2ndDegStep.SelectVar: return 'Select the variable';
      default: return '';
    }
  }

  @override
  bool hasFinished() => step == Delta2ndDegStep.Finished;

  @override
  Selectable isSelectable(Equation equation, Expression expression) {
    switch (step) {
    case Delta2ndDegStep.SelectVar:

      if (!(expression is Variable)) {
        return Selectable.None;
      }
      final varId = expression.name;

      final nonZeroParts = equation.parts.where((element) => !(element is LiteralConstant && element.number == BigInt.zero)).toList();
      if (nonZeroParts.length != 1) {
        return Selectable.None;
      }

      final part = nonZeroParts.first;
      final maxDegree = (part is Addition ? part.terms : [part]).fold<int>(
        0,
        (maxDegree, term) => max(
          maxDegree,
          (term is Multiplication ? term.factors : [term]).fold<int>(
            0,
            (degree, factor) => factor is Variable && factor.name == varId ? degree + 1 : degree,
          ),
        ),
      );

      return maxDegree == 2 ? (
        varId == this.selectedVarId
        ? Selectable.SingleSelected
        : Selectable.SingleEmpty
      ) : Selectable.None;
    default:
      return Selectable.None;
    }
  }

  @override
  bool canValidate() {
    return selectedEquation != null && selectedEquation != null;
  }

  @override
  EquationEditorState nextStep(EquationsCubit equationsCubit) {
    final newStep = Delta2ndDegStep.values[step.index + 1];
    if (newStep == Delta2ndDegStep.Finished) {

      for (var equation in equationsCubit.state.equations) {

        if (identical(equation, selectedEquation)) {
          equationsCubit.addEquations(
            Delta2ndDegTransformator(selectedVarId!).transformEquation(equation).map(
              (transformed) => applyTrivializersToEq(transformed).deepClone()
            ).toList()
          );
        }

      }

      return EquationEditorIdle();
    }
    return EquationEditorDelta2ndDeg(
      newStep,
        selectedEquation: selectedEquation,
        selectedVarId: selectedVarId,
    );
  }

  @override
  EquationEditorEditing onSelect(Equation equation, Expression expression) {
    switch (step) {
    case Delta2ndDegStep.SelectVar:
      return EquationEditorDelta2ndDeg(
        step,
        selectedEquation: equation,
        selectedVarId: (expression is Variable) ? expression.name : null,
      );
    default: return this;
    }
  }

}
