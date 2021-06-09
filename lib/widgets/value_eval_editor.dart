
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formula_transformator/core/equation_solvers/utils.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/cubit/value_evaluator_cubit.dart';
import 'package:formula_transformator/extensions.dart';
import 'package:formula_transformator/widgets/equation_widget.dart';

class ValueEvalEditor extends StatelessWidget {

  const ValueEvalEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<EquationsCubit, EquationsState>(
    builder: (context, equationsState) => BlocBuilder<ValueEvaluatorCubit, ValueEvaluatorState>(
      builder: (context, editorState) {

        final equationsWithConstants = equationsState.equations.map(
          (equation) => applyTrivializersToEq(injectConstValuesEquation(equation, editorState.solutions.constants))
        ).toList();

        final solutions = solveEquationSystem(equationsWithConstants, editorState.solutions);
        final allParts = equationsState.equations.flatMap(
          (equation) => equation.parts
        ).toList();
        final constIds = getNamedConstants(allParts);
        final varIds = getVariables(allParts);
        final constValues = solutions.constants;

        print('solutions: $solutions');

        return AlertDialog(
          title: const Text('Value evaluator'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...(constIds.isEmpty ? [] : [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: const Text('Constants:'),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ...constIds.map(
                      (constId) => (
                        constValues.containsKey(constId)
                        ? Row(children: [
                          Spacer(),
                          LatexWidget(
                            constId + '=' + constValues[constId].toString()
                          ),
                          ...(
                            editorState.solutions.constants.containsKey(constId)
                            ? [
                              IconButton(
                                icon: const Icon(Icons.delete, ),
                                iconSize: 20,
                                splashRadius: 18,
                                color: Colors.black,
                                onPressed: () => BlocProvider.of<ValueEvaluatorCubit>(context).unsetConstantValue(constId),
                              )
                            ]
                            : []
                          ),
                          Spacer(),
                        ])
                        : Row(children: [
                          Spacer(),
                          LatexWidget(constId + '='),
                          const SizedBox(width: 8),
                          Container(
                            height: 40,
                            width: 100,
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: TextField(
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(gapPadding: 1),
                                labelText: constId,
                              ),
                              onSubmitted: (value) => BlocProvider.of<ValueEvaluatorCubit>(context).setConstantValue(constId, BigInt.parse(value)),
                            ),
                          ),
                          Spacer(),
                        ])
                      )
                    ),
                  ],
                ),
              ]),
              ...(varIds.isEmpty ? [] : [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: const Text('Variables:'),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ...varIds.map(
                      (varId) => (
                        solutions.variables.containsKey(varId)
                        ? Row(children: [
                          Spacer(),
                          LatexWidget(
                            varId + '=' + solutions.variables[varId].toString()
                          ),
                          ...(
                            editorState.solutions.variables.containsKey(varId)
                            ? [
                              IconButton(
                                icon: const Icon(Icons.delete, ),
                                iconSize: 20,
                                splashRadius: 18,
                                color: Colors.black,
                                onPressed: () => BlocProvider.of<ValueEvaluatorCubit>(context).unsetVariableValue(varId),
                              )
                            ]
                            : []
                          ),
                          Spacer(),
                        ])
                        : Row(children: [
                          Spacer(),
                          LatexWidget(varId + '='),
                          const SizedBox(width: 8),
                          Container(
                            height: 40,
                            width: 100,
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: TextField(
                              // controller: TextEditingController
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(gapPadding: 1),
                                labelText: varId,
                              ),
                              onSubmitted: (value) => BlocProvider.of<ValueEvaluatorCubit>(context).setVariableValue(varId, BigInt.parse(value)),
                            ),
                          ),
                          Spacer(),
                        ])
                      )
                    ),
                  ],
                ),
              ]),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    ),
  );
}
