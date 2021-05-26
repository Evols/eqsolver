
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
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

  final Equation equation;
  final Widget? Function(Value)? bottomWidgetBuilder;

  const EquationWidget(this.equation, {Key? key, this.bottomWidgetBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final trivializedEq = Equation(applyTrivializers(equation.leftPart), applyTrivializers(equation.rightPart));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueWidget(trivializedEq.leftPart, bottomWidgetBuilder: bottomWidgetBuilder),
        Container(width: 4.0),
        LatexWidget('=', sizeFactor: 0.8),
        Container(width: 4.0),
        ValueWidget(trivializedEq.rightPart, bottomWidgetBuilder: bottomWidgetBuilder),
      ],
    );
  }
}
