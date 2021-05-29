
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_transformators/reorganize_transformator.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/cubit/equation_editor_cubit.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/utils.dart';

enum ReorganizeStep { Select, Finished }

@immutable
class EquationEditorReorganize extends EquationEditorEditing {

  final ReorganizeStep step;
  final List<Expression> selectedTerms;

  EquationEditorReorganize(this.step, [this.selectedTerms = const []]);

  @override
  String getStepName() {
    switch (step) {
      case ReorganizeStep.Select: return 'Select the terms to reorganize';
      default: return '';
    }
  }

  @override
  bool hasFinished() => step == ReorganizeStep.Finished;

  @override
  Selectable isSelectable(Equation equation, Expression expression) {
    switch (step) {
    case ReorganizeStep.Select:
      if (equation.parts.where(
        (part) => (identical(part, expression) && !(part is Addition)) || (part is Addition && part.terms.where(
          (term) => identical(term, expression)
        ).isNotEmpty)
      ).isNotEmpty) {
        return (
          selectedTerms.where((term) => identical(term, expression)).isNotEmpty
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
    case ReorganizeStep.Select:
      return selectedTerms.isNotEmpty;
    default:
      return true;
    }
  }

  @override
  EquationEditorState nextStep(EquationsCubit equationsCubit) {
    final newStep = ReorganizeStep.values[step.index + 1];
    if (newStep == ReorganizeStep.Finished) {

      for (var equation in equationsCubit.state.equations) {

        final isTheEquation = equation.findTree(
          (expression) => selectedTerms.where(
            (selectedTerm) => identical(expression, selectedTerm)
          ).isNotEmpty
        ) != null;

        if (isTheEquation) {
          equationsCubit.addEquations(
            ReorganizeTransformator(selectedTerms).transformEquation(equation).map(
              (transformed) => applyTrivializersToEq(transformed).deepClone()
            ).toList()
          );
        }

      }

      return EquationEditorIdle();
    }
    return EquationEditorReorganize(
      newStep,
      selectedTerms,
    );
  }

  @override
  EquationEditorEditing onSelect(Equation equation, Expression expression) {
    switch (step) {
    case ReorganizeStep.Select:
      return EquationEditorReorganize(
        step,
        flipExistenceArray<Expression>(selectedTerms, expression),
      );
    default:
      return this;
    }
  }

}
