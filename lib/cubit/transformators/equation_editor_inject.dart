
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/cubit/equation_editor_cubit.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';

enum InjectStep { SelectSubstitute, SelectInjection, Finished }

class EquationEditorInject extends EquationEditorEditing {

  final int eqIdx;
  final InjectStep step;
  final Value? selectedExpression;
  final Value? whereToInject;

  EquationEditorInject(this.eqIdx, this.step, { this.selectedExpression, this.whereToInject });

  @override
  String getStepName() {
    switch (step) {
      case InjectStep.SelectSubstitute: return 'Select the expression in the equation to inject';
      case InjectStep.SelectInjection: return 'Select the same expression where it will be injected';
      default: return '';
    }
  }

  @override
  bool hasFinished() => step == InjectStep.Finished;

  @override
  Selectable isSelectable(Value root, Value value) {
    switch (step) {
    case InjectStep.SelectSubstitute:
      if (value.getChildren().isEmpty && !(value is Constant)) {
        return (
          identical(selectedExpression, value)
          ? Selectable.SingleSelected
          : Selectable.SingleEmpty
        );
      }
      return Selectable.None;

    case InjectStep.SelectInjection:
      if (value.isEquivalentTo(selectedExpression!) && !identical(value, selectedExpression)) {
        return (
          identical(whereToInject, value)
          ? Selectable.SingleSelected
          : Selectable.SingleEmpty
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
    case InjectStep.SelectSubstitute:
      return selectedExpression != null;
    case InjectStep.SelectInjection:
      return whereToInject != null;
    default:
      return true;
    }
  }

  @override
  EquationEditorState nextStep(EquationsCubit equationsCubit) {
    final newStep = InjectStep.values[step.index + 1];
    // if (newStep == FactorizeStep.Finished) {

    //   for (var equation in equationsCubit.state.equations) {

    //     final addition = equation.findTree(
    //       (additionCandidate) => additionCandidate is Addition
    //       && additionCandidate.children.where(
    //         (multiplicateCandidate) => multiplicateCandidate is Multiplication
    //         // Multiplication term has the selected factors
    //         && multiplicateCandidate.children.where(
    //           (factor) => selectedFactors.where((selectedFactor) => identical(selectedFactor, factor)).isNotEmpty
    //         ).length == selectedFactors.length
    //       ).isNotEmpty
    //     );

    //     if (addition != null) {
    //       equationsCubit.addEquations(
    //         FactorizeTransformator(selectedFactors, selectedTerms).transform(addition).map(
    //           (transformed) => equation.mountAt(addition, transformed)
    //         ).toList()
    //       );
    //     }

    //   }

    //   return EquationEditorIdle();
    // }
    return EquationEditorInject(
      eqIdx,
      newStep,
      selectedExpression: selectedExpression,
      whereToInject: whereToInject,
    );
  }

  @override
  EquationEditorEditing onSelect(Value value) {
    switch (step) {
    case InjectStep.SelectSubstitute:
      return EquationEditorInject(
        eqIdx,
        step,
        selectedExpression: identical(value, selectedExpression) ? null : value,
        whereToInject: whereToInject,
      );
    case InjectStep.SelectInjection:
      return EquationEditorInject(
        eqIdx,
        step,
        selectedExpression: selectedExpression,
        whereToInject: identical(value, whereToInject) ? null : value,
      );
    default:
      return this;
    }
  }

}
