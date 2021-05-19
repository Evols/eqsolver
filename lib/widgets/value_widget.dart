
import 'package:flutter/cupertino.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/core/values/variable.dart';
import 'package:formula_transformator/utils.dart';
import 'package:formula_transformator/extensions.dart';

class ValueWidget extends StatelessWidget {

  final Value value;

  const ValueWidget(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inValue = value;

    // Widget for a constant
    if (inValue is Constant) {
      return latexToWidget('${inValue.number}');
    }
    // Widget for a variable
    else if (inValue is Variable) {
      return latexToWidget('${inValue.name}');
    }
    // Widget for an addition
    else if (inValue is Addition) {
      return Row(
        children: inValue.children
        .map((e) => ValueWidget(e))
        .foldIndexed<List<Widget>>(
          [],
          (previousValue, element, idx) => [
            ...previousValue,
            ...(idx == 0 ? [ element ] : [ Padding(padding: EdgeInsets.only(left: 4.0, right: 4.0), child: latexToWidget('+')), element ])
          ]
        )
        .toList()
      );
    }
    // Widget for a multiplication
    else if (inValue is Multiplication) {
      return Row(
        children: inValue.children
        .map((e) =>
          e is Addition
          ? Row(children: [ latexToWidget('('), ValueWidget(e), latexToWidget(')') ])
          : ValueWidget(e)
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

}