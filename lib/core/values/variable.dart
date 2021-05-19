
import 'package:flutter/widgets.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:formula_transformator/core/values/value.dart';

class Variable extends Value {

  final String id;

  const Variable(this.id);

  @override
  List<Value> getChildren() {
    return [];
  }

  @override
  Value deepClone() {
    return Variable(id);
  }

  @override
  Value deepCloneWithChildren(List<Value> newChildren) {
    return Variable(id);
  }

  @override
  Value getNormalized() {
    return this;
  }

  @override
  int compareTo(other) {
    if (!(other is Variable)) {
      return compareToClass(other);
    }
    return id.compareTo(other.id);
  }

  @override
  String toString() {
    return 'Variable($id)';
  }

  @override
  Widget toLatex() {
    return Math.tex(
      id,
      mathStyle: MathStyle.display,
      textScaleFactor: 1.4,
    );
  }

}
