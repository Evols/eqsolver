
import 'package:flutter/widgets.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/value.dart';

class EquationWidget extends StatelessWidget {

  final Value equation;

  const EquationWidget(this.equation, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trivialized = applyTrivializers(equation);
    if (trivialized is Addition) {
      // TODO
    }
    return Container();
  }
}
