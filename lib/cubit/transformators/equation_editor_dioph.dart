
import 'package:formula_transformator/core/value_transformators/dioph_transformator.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/cubit/equation_editor_cubit.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/utils.dart';

enum DiophStep { SelectTerms, Finished }

class EquationEditorDioph extends EquationEditorEditing {

  final int eqIdx;
  final DiophStep step;
  final List<Value> selectedTerms;

  EquationEditorDioph(this.eqIdx, this.step, { this.selectedTerms = const [] });

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
  Selectable isSelectable(Value root, Value value) {
    switch (step) {
    case DiophStep.SelectTerms:
      if (
        root is Addition && value is Multiplication
        && root.terms.length > 2
        && root.terms.where(
          (term) => identical(term, value)
        ).isNotEmpty && value.factors.where(
          (factor) => factor is Constant
        ).isNotEmpty && root.terms.where(
          (term) => selectedTerms.where(
            (selectedTerm) => identical(term, selectedTerm)
          ).isNotEmpty
        ).length == selectedTerms.length
      ) {
        return (
          selectedTerms.where((e) => identical(e, value)).isNotEmpty
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
    return selectedTerms.length == 2;
  }

  @override
  EquationEditorState nextStep(EquationsCubit equationsCubit) {
    final newStep = DiophStep.values[step.index + 1];
    if (newStep == DiophStep.Finished) {

      for (var equation in equationsCubit.state.equations) {

        final isTheEquation = equation is Addition && equation.terms.where(
          (term) => selectedTerms.where(
            (selectedTerm) => identical(term, selectedTerm)
          ).isNotEmpty
        ).isNotEmpty;

        if (isTheEquation) {
          equationsCubit.addEquations(
            DiophTransformator(selectedTerms).transform(equation).map(
              (transformed) => applyTrivializers(transformed).deepClone()
            ).toList()
          );
        }

      }

      return EquationEditorIdle();
    }
    return EquationEditorDioph(
      eqIdx,
      newStep,
      selectedTerms: selectedTerms,
    );
  }

  @override
  EquationEditorEditing onSelect(Value root, Value value) {
    switch (step) {
    case DiophStep.SelectTerms:
      return EquationEditorDioph(
        eqIdx,
        step,
        selectedTerms: flipExistenceArray<Value>(selectedTerms, value),
      );
    default: return this;
    }
  }

}
