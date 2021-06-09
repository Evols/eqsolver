
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/gcd.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/named_constant.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:formula_transformator/extensions.dart';

import 'equation_widget.dart';


@immutable
class ExpressionWidget extends StatelessWidget {

  final Expression expression;
  final Widget? Function(Expression)? bottomWidgetBuilder;

  const ExpressionWidget(this.expression, {Key? key, this.bottomWidgetBuilder}) : super(key: key);

  Widget buildLatex() {

    final inExpression = expression;

    // Widget for a literal constant
    if (inExpression is LiteralConstant) {
      return LatexWidget('${inExpression.number}');
    }
    // Widget for a named constant
    if (inExpression is NamedConstant) {
      return LatexWidget('${inExpression.name}');
    }
    // Widget for a variable
    else if (inExpression is Variable) {
      return LatexWidget('${inExpression.name}');
    }
    // Widget for an addition
    else if (inExpression is Addition) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: inExpression.terms
        .map((e) => ExpressionWidget(e, bottomWidgetBuilder: this.bottomWidgetBuilder))
        .foldIndexed<List<Widget>>(
          [],
          (previousValue, element, idx) => [
            ...previousValue,
            ...(
              idx == 0
              ? [ element ]
              : [ Padding(padding: EdgeInsets.only(left: 4.0, right: 4.0), child: LatexWidget('+')), element ]
            ),
          ]
        )
        .toList()
      );
    }
    // Widget for a multiplication
    else if (inExpression is Multiplication) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: inExpression.factors
        .map((e) =>
          e is Addition
          ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ LatexWidget('('), ExpressionWidget(e, bottomWidgetBuilder: this.bottomWidgetBuilder), LatexWidget(')') ]
          )
          : ExpressionWidget(e, bottomWidgetBuilder: this.bottomWidgetBuilder)
        )
        .foldIndexed<List<Widget>>([],
          (previousValue, element, idx) => [
            ...previousValue,
            ...(idx == 0 ? [ element ] : [ Container(width: 2.0), element ])])
        .toList()
      );
    }
    // Widget for a gcd
    else if (inExpression is Gcd) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LatexWidget(r'\gcd('),
          ...inExpression.args
          .map((e) => ExpressionWidget(e, bottomWidgetBuilder: this.bottomWidgetBuilder))
          .foldIndexed<List<Widget>>(
            [],
            (previousValue, element, idx) => [
              ...previousValue,
              ...(
                idx == 0
                ? [ element ]
                : [ Padding(padding: EdgeInsets.only(left: 2.0, right: 4.0), child: SizedBox(height: 30, child: LatexWidget(','))), element ]
              ),
            ]
          )
          .toList(),
          LatexWidget(r')'),
        ],
      );
    }
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {

    final bottomWidget = bottomWidgetBuilder != null ? bottomWidgetBuilder!(expression) : null;

    return Container(
      decoration: bottomWidget != null ? const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.black12),
          left: BorderSide(width: 1.0, color: Colors.black12),
          right: BorderSide(width: 1.0, color: Colors.black12),
          bottom: BorderSide(width: 1.0, color: Colors.black12),
        ),
      ) : null,
      child: Column(
        children: [
          buildLatex(),
          ...(bottomWidget != null ? [bottomWidget] : [])
        ],
      ),
    );
  }

}
