
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_transformators/inject_transformator.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/cubit/equation_editor_cubit.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';

enum InjectStep { SelectSubstitute, SelectInjection, Finished }

@immutable
class EquationEditorInject extends EquationEditorEditing {

  final InjectStep step;
  final Equation? sourceEquation;
  final Expression? sourceExpression;
  final Expression? targetExpression;

  EquationEditorInject(this.step, { this.sourceEquation, this.sourceExpression, this.targetExpression });

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
  Selectable isSelectable(Equation equation, Expression expression) {
    switch (step) {
    case InjectStep.SelectSubstitute:
      if (equation.parts.where(
        (part) => identical(part, expression) || part is Multiplication && part.factors.where(
          (factor) => identical(factor, expression)
        ).isNotEmpty
      ).isNotEmpty && !(expression is LiteralConstant)) {
        return (
          identical(sourceExpression, expression)
          ? Selectable.SingleSelected
          : Selectable.SingleEmpty
        );
      }
      return Selectable.None;

    case InjectStep.SelectInjection:
      if (expression.isEquivalentTo(sourceExpression!) && !identical(expression, sourceExpression) && equation.parts.where(
        (part) => identical(part, expression) || part is Multiplication && part.factors.where(
          (factor) => identical(factor, expression)
        ).isNotEmpty
      ).isNotEmpty) {
        return (
          identical(targetExpression, expression)
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

        final isTheEquation = equation.findTree(
          (expression) => identical(expression, targetExpression)
        ) != null;

        if (isTheEquation) {
          equationsCubit.addEquations(
            InjectTransformator(sourceEquation!, sourceExpression!, targetExpression!).transformEquation(equation).map(
              (transformed) => applyTrivializersToEq(transformed).deepClone()
            ).toList()
          );
        }

      }

      return EquationEditorIdle();
    }
    return EquationEditorInject(
      newStep,
      sourceEquation: sourceEquation,
      sourceExpression: sourceExpression,
      targetExpression: targetExpression,
    );
  }

  @override
  EquationEditorEditing onSelect(Equation equation, Expression expression) {
    switch (step) {
    case InjectStep.SelectSubstitute:
      final shouldNullify = identical(expression, sourceExpression);
      return EquationEditorInject(
        step,
        sourceEquation: shouldNullify ? null : equation,
        sourceExpression: shouldNullify ? null : expression,
        targetExpression: targetExpression,
      );
    case InjectStep.SelectInjection:
      return EquationEditorInject(
        step,
        sourceEquation: sourceEquation,
        sourceExpression: sourceExpression,
        targetExpression: identical(expression, targetExpression) ? null : expression,
      );
    default:
      return this;
    }
  }

}
