
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/literal_constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/core/values/variable.dart';
import 'package:formula_transformator/extensions.dart';

import 'equation_widget.dart';


class ValueWidget extends StatelessWidget {

  final Value value;
  final Widget? Function(Value)? bottomWidgetBuilder;

  const ValueWidget(this.value, {Key? key, this.bottomWidgetBuilder}) : super(key: key);

  Widget buildLatex() {

    final inValue = value;

    // Widget for a constant
    if (inValue is LiteralConstant) {
      return LatexWidget('${inValue.number}');
    }
    // Widget for a variable
    else if (inValue is Variable) {
      return LatexWidget('${inValue.name}');
    }
    // Widget for an addition
    else if (inValue is Addition) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: inValue.terms
        .map((e) => ValueWidget(e, bottomWidgetBuilder: this.bottomWidgetBuilder))
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
    else if (inValue is Multiplication) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: inValue.factors
        .map((e) =>
          e is Addition
          ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ LatexWidget('('), ValueWidget(e, bottomWidgetBuilder: this.bottomWidgetBuilder), LatexWidget(')') ]
          )
          : ValueWidget(e, bottomWidgetBuilder: this.bottomWidgetBuilder)
        )
        .foldIndexed<List<Widget>>([],
          (previousValue, element, idx) => [
            ...previousValue,
            ...(idx == 0 ? [ element ] : [ Container(width: 2.0), element ])])
        .toList()
      );
    }
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {

    final bottomWidget = bottomWidgetBuilder != null ? bottomWidgetBuilder!(value) : null;

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
