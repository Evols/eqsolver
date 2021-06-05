
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formula_transformator/core/equation_solvers/utils.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/cubit/value_evaluator_cubit.dart';
import 'package:formula_transformator/extensions.dart';
import 'package:formula_transformator/widgets/equation_widget.dart';

class ValueEvalEditor extends StatelessWidget {

  const ValueEvalEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<EquationsCubit, EquationsState>(
    builder: (context, equationsState) => BlocProvider<ValueEvaluatorCubit>(
      create: (_) => ValueEvaluatorCubit(BlocProvider.of<EquationsCubit>(context)),
      child: BlocBuilder<ValueEvaluatorCubit, ValueEvaluatorState>(
        builder: (context, editorState) {

          final solutions = solveEquationSystem(equationsState.equations, editorState.values);
          final varIds = getVars(equationsState.equations.flatMap(
            (equation) => equation.parts
          ).toList());

          print('solutions: $solutions');

          return AlertDialog(
            title: const Text('Value evaluator'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ...varIds.map(
                  (varId) => (
                    solutions.containsKey(varId)
                    ? LatexWidget(
                      varId + '=' + solutions[varId].toString()
                    )
                    : Row(children: [
                      Spacer(),
                      LatexWidget(varId + '='),
                      Container(width: 8),
                      Container(
                        height: 40,
                        width: 100,
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: const OutlineInputBorder(gapPadding: 1),
                            labelText: 'Valeur',
                          ),
                          onSubmitted: (value) => BlocProvider.of<ValueEvaluatorCubit>(context).setValue(varId, BigInt.parse(value)),
                        ),
                      ),
                      Spacer(),
                    ])
                  )
                )
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