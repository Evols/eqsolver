
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/cubit/value_evaluator_cubit.dart';
import 'package:formula_transformator/extensions.dart';

class ValueEvalEditor extends StatelessWidget {
  const ValueEvalEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<EquationsCubit, EquationsState>(
    builder: (context, equationsState) => BlocProvider<ValueEvaluatorCubit>(
      create: (_) => ValueEvaluatorCubit(BlocProvider.of<EquationsCubit>(context)),
      child: BlocBuilder<ValueEvaluatorCubit, ValueEvaluatorState>(
        builder: (context, editorState) {

          final varIdsByEquations = equationsState.equations.map(
            (equation) => equation.parts.flatMap(
              (part) => part.foldTree<Set<String>>(
                {},
                (accumulator, expression) => expression is Variable ? { ...accumulator, expression.name } : accumulator
              )
            ).toSet()
          ).toList();

          print('varIdsByEquations: $varIdsByEquations');

          final allVarIds = varIdsByEquations.flatMap((varIds) => varIds).toSet();

          print('allVarIds: $allVarIds');

          return AlertDialog(
            title: const Text('Value evaluator'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Evaluate values'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        }
      ),
    ),
  );
}