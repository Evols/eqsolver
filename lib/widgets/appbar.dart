
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formula_transformator/cubit/equation_editor_cubit.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/widgets/button.dart';

class MainAppbar extends AppBar {

  final String titleName;

  MainAppbar({ Key? key, required this.titleName }) : super(
    key: key,
    title: BlocBuilder<EquationsCubit, EquationsState>(
      builder: (context, state) => BlocBuilder<EquationEditorCubit, EquationEditorState>(
        builder: (context, editorState) => Flex(
          direction: MediaQuery.of(context).size.width > 900 ? Axis.horizontal : Axis.vertical,
          children: [
            Text(titleName + (editorState is EquationEditorEditing ? ' - ' + editorState.getStepName() : '')),
            ...(
              MediaQuery.of(context).size.width > 900 ? [Spacer()] : []
            ),
            BlocBuilder<EquationEditorCubit, EquationEditorState>(
              builder: (context, editorState) => Row(
                children: (
                  editorState is EquationEditorEditing
                  ? [
                    Button(
                      'Cancel',
                      onPressed: () => BlocProvider.of<EquationEditorCubit>(context).cancel(),
                    ),
                    Text(' '),
                    Button(
                      'Validate',
                      onPressed: !editorState.canValidate() ? null : () => BlocProvider.of<EquationEditorCubit>(context).nextStep(),
                    ),
                  ]
                  : []
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
