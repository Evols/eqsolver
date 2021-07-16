
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formula_transformator/cubit/equation_adder_cubit.dart';
import 'package:formula_transformator/widgets/equation_widget.dart';

class EquationAdderEditor extends StatefulWidget {
  EquationAdderEditor({Key? key}) : super(key: key);

  @override
  _EquationAdderEditorState createState() => _EquationAdderEditorState();
}

class _EquationAdderEditorState extends State<EquationAdderEditor> {

  @override
  void deactivate() {
    BlocProvider.of<EquationAdderCubit>(context).closeValidation(context);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<EquationAdderCubit, EquationAdderState>(
    builder: (context, equationAdderState) => AlertDialog(
      title: const Text('Add equation'),
      content: (
        equationAdderState is EquationAdderValidating
        ? Column(
          children: [
            ...equationAdderState.computedAlphaExprTypes.entries.map(
              (entry) => Row(
                children: [
                  const Spacer(),
                  LatexWidget(entry.key + ':'),
                  const Spacer(),
                  const Text('Variable'),
                  Switch(value: equationAdderState.computedAlphaExprTypes[entry.key] == AlphaExprType.Constant, onChanged: null),
                  const Text('Constant'),
                ],
              ),
            ),
            ...equationAdderState.editedAlphaExprTypes.entries.map(
              (entry) => Row(
                children: [
                  const Spacer(),
                  LatexWidget(entry.key + ':'),
                  const Spacer(),
                  const Text('Variable'),
                  Switch(value: equationAdderState.editedAlphaExprTypes[entry.key] == AlphaExprType.Constant, onChanged: (isConst) {
                    final oldType = equationAdderState.editedAlphaExprTypes[entry.key];
                    if (oldType != null) {
                      BlocProvider.of<EquationAdderCubit>(context).updateAlphaExprType(entry.key, isConst ? AlphaExprType.Constant : AlphaExprType.Variable);
                    }
                  }),
                  const Text('Constant'),
                ],
              ),
            ),
          ],
        )
        : Container()
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => BlocProvider.of<EquationAdderCubit>(context).addValidatedEquation(context),
          child: const Text('Validate'),
        ),
        TextButton(
          onPressed: () => BlocProvider.of<EquationAdderCubit>(context).closeValidation(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
