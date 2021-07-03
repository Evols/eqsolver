
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formula_transformator/cubit/equation_editor_cubit.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/widgets/button.dart';
import 'package:formula_transformator/widgets/value_eval_editor.dart';

class MainAppbar extends AppBar {

  final String titleName;

  MainAppbar({ Key? key, required this.titleName }) : super(
    key: key,
    title: BlocBuilder<EquationsCubit, EquationsState>(
      builder: (context, state) => BlocBuilder<EquationEditorCubit, EquationEditorState>(
        builder: (context, editorState) => Row(
          children: [
            Text(titleName + (editorState is EquationEditorEditing ? ' - ' + editorState.getStepName() : '')),
            ...(
              editorState is EquationEditorIdle
              ? [
                Container(width: 8),
                Button(
                  'Compute the values of variables',
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => ValueEvalEditor(),
                  ),
                ),
              ]
              : []
            ),
            Spacer(),
            BlocBuilder<EquationEditorCubit, EquationEditorState>(
              builder: (context, editorState) {
                return Row(
                  children: [
                    ...(editorState is EquationEditorEditing ? [
                      Button(
                        'Cancel',
                        onPressed: () => BlocProvider.of<EquationEditorCubit>(context).cancel(),
                      ),
                      Text(' '),
                      Button(
                        'Validate',
                        onPressed: !editorState.canValidate() ? null : () => BlocProvider.of<EquationEditorCubit>(context).nextStep(),
                      ),
                    ] : []),
                  ],
                );
              }
            )
          ]
        ),
      ),
    ),
  );
}
