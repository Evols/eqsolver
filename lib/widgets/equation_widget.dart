
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/widgets/value_widget.dart';

class LatexWidget extends StatelessWidget {

  final String latex;
  final double sizeFactor;

  const LatexWidget(this.latex, {Key? key, this.sizeFactor = 1.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.0,
      alignment: Alignment.center,
      child: Math.tex(
        latex,
        mathStyle: MathStyle.display,
        textScaleFactor: 1.4 * sizeFactor,
      )
    );
  }
}

class EquationWidget extends StatelessWidget {

  final Value equation;
  final bool prettify;
  final Widget? Function(Value)? bottomWidgetBuilder;

  const EquationWidget(this.equation, {Key? key, this.bottomWidgetBuilder, required this.prettify}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final trivialized = applyTrivializers(equation);
    if (prettify && trivialized is Addition) {

      var positives = <Value>[], negatives = <Value>[];

      for (var term in trivialized.terms) {
        if (term is Constant && term.number < 0 || term is Multiplication && term.factors.where((factor) => factor is Constant && factor.number < 0).length > 0) {
          negatives.add(term);
        } else {
          positives.add(term);
        }
      }

      if (negatives.isNotEmpty) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueWidget(applyTrivializers(Addition(positives)), bottomWidgetBuilder: bottomWidgetBuilder),
            Container(width: 4.0),
            LatexWidget('=', sizeFactor: 0.8),
            Container(width: 4.0),
            ValueWidget(applyTrivializers(Multiplication([
              Constant(-1),
              Addition(negatives),
            ])), bottomWidgetBuilder: bottomWidgetBuilder),
          ],
        );
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueWidget(applyTrivializers(trivialized), bottomWidgetBuilder: bottomWidgetBuilder),
        Container(width: 4.0),
        LatexWidget('= 0'),
      ],
    );
  }
}
