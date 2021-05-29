
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_transformators/dioph_transformator.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/cubit/equation_editor_cubit.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';

enum DiophStep { SelectTerms, Finished }

@immutable
class EquationEditorDioph extends EquationEditorEditing {

  final int eqIdx;
  final DiophStep step;
  final Addition? selectedAddition;

  EquationEditorDioph(this.eqIdx, this.step, { this.selectedAddition });

  @override
  String getStepName() {
    switch (step) {
      case DiophStep.SelectTerms: return 'Select the terms to diophantize';
      default: return '';
    }
  }

  @override
  bool hasFinished() => step == DiophStep.Finished;

  @override
  Selectable isSelectable(Equation equation, Value value) {
    switch (step) {
    case DiophStep.SelectTerms:
      if (
        equation.parts.where(
          (part) => (
            part is Addition
            && identical(part, value)
            && part.terms.length == 2
            && part.terms.where(
              (term) => term is Multiplication && term.factors.where((factor) => factor.isConstant).isNotEmpty
            ).length == 2
          ) 
        ).isNotEmpty
      ) {
        return (
          identical(selectedAddition, value)
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
    return selectedAddition != null;
  }

  @override
  EquationEditorState nextStep(EquationsCubit equationsCubit) {
    final newStep = DiophStep.values[step.index + 1];
    if (newStep == DiophStep.Finished) {

      for (var equation in equationsCubit.state.equations) {

        if (equation.findTree((child) => identical(selectedAddition, child)) != null) {
          equationsCubit.addEquations(
            DiophTransformator(selectedAddition!).transformEquation(equation).map(
              (transformed) => applyTrivializersToEq(transformed).deepClone()
            ).toList()
          );
        }

      }

      return EquationEditorIdle();
    }
    return EquationEditorDioph(
      eqIdx,
      newStep,
      selectedAddition: selectedAddition,
    );
  }

  @override
  EquationEditorEditing onSelect(Equation equation, Value value) {
    switch (step) {
    case DiophStep.SelectTerms:
      return EquationEditorDioph(
        eqIdx,
        step,
        selectedAddition: (selectedAddition == null && value is Addition) ? value : null,
      );
    default: return this;
    }
  }

}
