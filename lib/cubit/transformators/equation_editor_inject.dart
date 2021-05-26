
import 'package:formula_transformator/core/equation_transformators/inject_transformator.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/cubit/equation_editor_cubit.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';

enum InjectStep { SelectSubstitute, SelectInjection, Finished }

class EquationEditorInject extends EquationEditorEditing {

  final int eqIdx;
  final InjectStep step;
  final Addition? sourceEquation;
  final Value? sourceExpression;
  final Value? targetExpression;

  EquationEditorInject(this.eqIdx, this.step, { this.sourceEquation, this.sourceExpression, this.targetExpression });

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
      if (root is Addition && root.terms.where(
        (term) => identical(term, value) || (term is Multiplication && term.factors.where(
          (factor) => identical(factor, value)
        ).isNotEmpty)
      ).isNotEmpty && value.getChildren().isEmpty && !(value is Constant)) {
        return (
          identical(sourceExpression, value)
          ? Selectable.SingleSelected
          : Selectable.SingleEmpty
        );
      }
      return Selectable.None;

    case InjectStep.SelectInjection:
      if (value.isEquivalentTo(sourceExpression!) && !identical(value, sourceExpression) && root is Addition && root.terms.where(
        (term) => identical(term, value) || (term is Multiplication && term.factors.where(
          (factor) => identical(factor, value)
        ).isNotEmpty)
      ).isNotEmpty) {
        return (
          identical(targetExpression, value)
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
      return sourceExpression != null && sourceEquation != null;
    case InjectStep.SelectInjection:
      return targetExpression != null;
    default:
      return true;
    }
  }

  @override
  EquationEditorState nextStep(EquationsCubit equationsCubit) {
    final newStep = InjectStep.values[step.index + 1];
    if (newStep == InjectStep.Finished) {

      for (var equation in equationsCubit.state.equations) {

        final isTheEquation = equation is Addition && equation.terms.where(
          (term) => identical(term, targetExpression) || (term is Multiplication && term.factors.where(
            (factor) => identical(factor, targetExpression)
          ).isNotEmpty)
        ).isNotEmpty;

        if (isTheEquation) {
          equationsCubit.addEquations(
            InjectTransformator(sourceEquation!, sourceExpression!, targetExpression!).transformValue(equation).map(
              (transformed) => applyTrivializers(transformed).deepClone()
            ).toList()
          );
        }

      }

      return EquationEditorIdle();
    }
    return EquationEditorInject(
      eqIdx,
      newStep,
      sourceEquation: sourceEquation,
      sourceExpression: sourceExpression,
      targetExpression: targetExpression,
    );
  }

  @override
  EquationEditorEditing onSelect(Value root, Value value) {
    switch (step) {
    case InjectStep.SelectSubstitute:
      final shouldNullify = identical(value, sourceExpression);
      return EquationEditorInject(
        eqIdx,
        step,
        sourceEquation: shouldNullify ? null : (root as Addition),
        sourceExpression: shouldNullify ? null : value,
        targetExpression: targetExpression,
      );
    case InjectStep.SelectInjection:
      return EquationEditorInject(
        eqIdx,
        step,
        sourceEquation: sourceEquation,
        sourceExpression: sourceExpression,
        targetExpression: identical(value, targetExpression) ? null : value,
      );
    default:
      return this;
    }
  }

}
