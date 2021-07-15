
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/expressions/named_constant.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:formula_transformator/core/parser.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/widgets/equation_adder_editor.dart';
import 'package:formula_transformator/extensions.dart';

part 'equation_adder_state.dart';

class EquationAdderCubit extends Cubit<EquationAdderState> {

  final EquationsCubit equationsCubit;

  EquationAdderCubit(this.equationsCubit) : super(EquationAdderTextfield(''));

  void updateTextfield(String tempEq) {
    if (state is EquationAdderTextfield) {
      emit(EquationAdderTextfield(tempEq));
    }
  }

  void validateTextfield(BuildContext context) {
    final state = this.state;
    if (state is EquationAdderTextfield) {
      showDialog(
        context: context,
        builder: (_) => EquationAdderEditor(),
      );
      final parsedEq = parse(state.content);
      final exprTypes = computeAlphaExprTypes(parsedEq, equationsCubit.state.equations);
      final computedExprTypes = exprTypes.where(
        (key, value) => value != null
      ).map(
        (key, value) => MapEntry(key, value!),
      );
      final editedExprTypes = exprTypes.where(
        (key, value) => value == null
      ).map(
        (key, value) => MapEntry(key, AlphaExprType.Variable),
      );
      emit(EquationAdderValidating(parsedEq, computedExprTypes, editedExprTypes));
    }
  }
}

enum AlphaExprType {
  Variable,
  Constant,
}

Map<String, AlphaExprType?> computeAlphaExprTypes(Equation newEquation, List<Equation> existingEquations) => Map.fromEntries(
  newEquation.parts.flatMap(
    (part) => part.foldTree<List<String>>(
      <String>[],
      (acc, expression) => expression is Variable ? [...acc, expression.name] : acc,
    )
  ).map(
    (varName) => MapEntry(
      varName,
      existingEquations.fold<AlphaExprType?>(
        null,
        (acc, equation) => acc ?? equation.parts.fold<AlphaExprType?>(
          null,
          (acc, part) => acc ?? part.foldTree<AlphaExprType?>(
            null,
            (acc, expression) {
              if (acc != null) {
                return acc;
              }
              if (expression is Variable && expression.name == varName) {
                return AlphaExprType.Variable;
              }
              if (expression is NamedConstant && expression.name == varName) {
                return AlphaExprType.Constant;
              }
              return null;
            },
          ),
        ),
      ),
    ),
  )
);
