
import 'package:flutter/widgets.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/utils.dart';
import 'package:formula_transformator/widgets/value_widget.dart';

class EquationWidget extends StatelessWidget {

  final Value equation;

  const EquationWidget(this.equation, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final trivialized = applyTrivializers(equation);
    if (trivialized is Addition) {

      var positives = <Value>[], negatives = <Value>[];

      for (var term in trivialized.children) {
        if (term is Constant && term.number < 0 || term is Multiplication && term.children.where((factor) => factor is Constant && factor.number < 0).length > 0) {
          negatives.add(term);
        } else {
          positives.add(term);
        }
      }

      if (negatives.isNotEmpty) {
        return Row(children: [
          ValueWidget(applyTrivializers(Addition(positives))),
          Container(width: 4.0),
          latexToWidget('='),
          Container(width: 4.0),
          ValueWidget(applyTrivializers(Multiplication([
            Constant(-1),
            Addition(negatives),
          ]))),
        ]);
      }
    }

    return Row(children: [
      ValueWidget(applyTrivializers(trivialized)),
      latexToWidget('= 0'),
    ]);
  }
}
