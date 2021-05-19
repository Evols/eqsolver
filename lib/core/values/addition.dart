
import 'package:flutter/widgets.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/utils.dart';

import '../utils.dart';
import 'package:formula_transformator/extensions.dart';

class Addition extends Value {

  final List<Value> children;

  const Addition(this.children);

  @override
  List<Value> getChildren() {
    return children;
  }

  @override
  Value deepClone() {
    return Addition(children.map((e) => e.deepClone()).toList());
  }

  @override
  Value deepCloneWithChildren(List<Value> newChildren) {
    return Addition(newChildren);
  }

  @override
  Value getNormalized() {
    final childrenNormalized = children.map((e) => e.getNormalized()).toList();
    childrenNormalized.sort();
    return Addition(childrenNormalized);
  }

  @override
  int compareTo(other) {
    if (!(other is Addition)) {
      return compareToClass(other);
    }
    return compareLists(children, other.children);
  }

  @override
  String toString() {
    return 'Addition( ${children.map((e) => e.toString()).toList().join(', ')} )';
  }

  @override
  Widget toLatex() {
    return Row(
      children: children
      .map((e) => e.toLatex())
      .foldIndexed<List<Widget>>([],
        (previousValue, element, idx) => [
          ...previousValue,
          ...(idx == 0 ? [ element ] : [ Padding(padding: EdgeInsets.only(left: 4.0, right: 4.0), child: latexToWidget('+')), element ])])
      .toList()
    );
  }

}
