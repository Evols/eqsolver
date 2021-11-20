
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/widgets/equation_widget.dart';

class ImportEquationsModal extends HookWidget {

  final List<Equation> newEquations;
  const ImportEquationsModal(this.newEquations, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final selectedEquations = useState<Set<Equation>>(newEquations.toSet());

    return AlertDialog(
      title: const Text('Import equations'),
      content: SizedBox(
        height: 420,
        child: SingleChildScrollView(
          child: Column(
            children: newEquations.map(
              (eq) => Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EquationWidget(
                        eq,
                        bottomWidgetBuilder: (expression) => null,
                      ),
                      Checkbox(
                        splashRadius: 0.0,
                        value: selectedEquations.value.lookup(eq) != null,
                        onChanged: (_) => (
                          selectedEquations.value.lookup(eq) != null
                          ? (selectedEquations.value = selectedEquations.value.where((it) => it != eq).toSet())
                          : (selectedEquations.value = { ...selectedEquations.value, eq })
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // TODO
          },
          child: const Text('Append'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // TODO
          },
          child: const Text('Replace'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
