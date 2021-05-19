
import 'package:flutter/widgets.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/utils.dart';

import '../utils.dart';
import 'addition.dart';
import 'package:formula_transformator/extensions.dart';

class Multiplication extends Value {

  final List<Value> children;

  const Multiplication(this.children);

  @override
  List<Value> getChildren() {
    return children;
  }

  @override
  Value deepClone() {
    return Multiplication(children.map((e) => e.deepClone()).toList());
  }

  @override
  Value deepCloneWithChildren(List<Value> newChildren) {
    return Multiplication(newChildren);
  }

  @override
  Value getNormalized() {
    final childrenNormalized = children.map((e) => e.getNormalized()).toList();
    childrenNormalized.sort();
    return Multiplication(childrenNormalized);
  }

  @override
  int compareTo(other) {
    if (!(other is Multiplication)) {
      return compareToClass(other);
    }
    return compareLists(children, other.children);
  }

  @override
  String toString() {
    return 'Multiplication( ${children.map((e) => e.toString()).toList().join(', ')} )';
  }
  @override
  Widget toLatex() {
    return Row(
      children: children
      .map((e) =>
        e is Addition
        ? Row(children: [ latexToWidget('('), e.toLatex(), latexToWidget(')') ])
        : e.toLatex()
      )
      .foldIndexed<List<Widget>>([],
        (previousValue, element, idx) => [
          ...previousValue,
          ...(idx == 0 ? [ element ] : [ Container(width: 2.0), element ])])
      .toList()
    );
  }
}
