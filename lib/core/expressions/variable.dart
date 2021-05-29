
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

@immutable
class Variable extends Expression {

  final String name;

  const Variable(this.name);

  @override
  List<Expression> getChildren() {
    return [];
  }

  @override
  Expression deepClone() {
    return Variable(name);
  }

  @override
  Expression deepCloneWithChildren(List<Expression> newChildren) {
    return Variable(name);
  }

  @override
  Expression getNormalized() {
    return this;
  }

  @override
  bool get isConstant => false;

  @override
  int compareTo(other) {
    if (!(other is Variable)) {
      return compareToClass(other);
    }
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return 'Variable($name)';
  }

}
