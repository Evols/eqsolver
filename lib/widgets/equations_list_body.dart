
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:formula_transformator/cubit/equation_editor_cubit.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/widgets/equation_widget.dart';

class EquationsListBody extends StatelessWidget {

  const EquationsListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<EquationsCubit, EquationsState>(
    builder: (context, state) => BlocBuilder<EquationEditorCubit, EquationEditorState>(
      builder: (context, editorState) => ListView.builder(
        itemCount: state.equations.length,
        itemBuilder: (context, index) => Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EquationWidget(
                  state.equations[index],
                  bottomWidgetBuilder: (expression) {
                    if (editorState is EquationEditorEditing) {
                      final selectable = editorState.isSelectable(state.equations[index], expression);
                      switch (selectable) {
                      case Selectable.SingleEmpty:
                      case Selectable.SingleSelected:
                        return Radio<bool>(
                          splashRadius: 0.0,
                          value: selectable == Selectable.SingleSelected,
                          groupValue: true,
                          onChanged: (_) => BlocProvider.of<EquationEditorCubit>(context).onSelect(state.equations[index], expression),
                        );
                      case Selectable.MultipleEmpty:
                      case Selectable.MultipleSelected:
                        return Checkbox(
                          splashRadius: 0.0,
                          value: selectable == Selectable.MultipleSelected,
                          onChanged: (_) => BlocProvider.of<EquationEditorCubit>(context).onSelect(state.equations[index], expression),
                        );
                        case Selectable.None:
                          return null;
                      }
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Math.tex(
                      '(${index+1})',
                      mathStyle: MathStyle.display,
                      textScaleFactor: 1.2,
                    ),
                    DropdownButton<void Function()>(
                      selectedItemBuilder: (context) => [ Container( width: 50,) ],
                      iconSize: 24,
                      elevation: 16,
                      isDense: true,
                      underline: Container(),
                      onChanged: (void Function()? newValue) => newValue?.call(),
                      items: editorState is EquationEditorEditing ? [] : [
                        DropdownMenuItem<void Function()>(
                          value: () => BlocProvider.of<EquationEditorCubit>(context).startDevelopping(),
                          child: Container(child: Text('Develop', style: TextStyle(fontSize: 14))),
                        ),
                        DropdownMenuItem<void Function()>(
                          value: () => BlocProvider.of<EquationEditorCubit>(context).startFactoring(),
                          child: Container(child: Text('Factor', style: TextStyle(fontSize: 14))),
                        ),
                        DropdownMenuItem<void Function()>(
                          value: () => BlocProvider.of<EquationEditorCubit>(context).startDioph(),
                          child: Container(child: Text('Diophantine', style: TextStyle(fontSize: 14))),
                        ),
                        DropdownMenuItem<void Function()>(
                          value: () => BlocProvider.of<EquationEditorCubit>(context).startInject(),
                          child: Container(child: Text('Inject', style: TextStyle(fontSize: 14))),
                        ),
                        DropdownMenuItem<void Function()>(
                          value: () => BlocProvider.of<EquationEditorCubit>(context).startReorganize(),
                          child: Container(child: Text('Reorganize', style: TextStyle(fontSize: 14))),
                        ),
                        DropdownMenuItem<void Function()>(
                          value: () => BlocProvider.of<EquationEditorCubit>(context).startDelta2ndDeg(),
                          child: Container(child: Text('Delta 2nd deg', style: TextStyle(fontSize: 14))),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
