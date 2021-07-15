
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formula_transformator/cubit/equation_adder_cubit.dart';
import 'package:formula_transformator/widgets/equation_widget.dart';

class EquationAdderEditor extends StatelessWidget {

  const EquationAdderEditor({Key? key}) : super(key: key);

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
                  Spacer(),
                  LatexWidget(entry.key + ':'),
                  Spacer(),
                  const Text('Variable'),
                  const Switch(value: true, onChanged: null),
                  const Text('Constant'),
                ],
              ),
            ),
            ...equationAdderState.editedAlphaExprTypes.entries.map(
              (entry) => Row(
                children: [
                  Spacer(),
                  LatexWidget(entry.key + ':'),
                  Spacer(),
                  const Text('Variable'),
                  Switch(value: true, onChanged: (_) {}),
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
          onPressed: () => Navigator.pop(context),
          child: const Text('Validate'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
