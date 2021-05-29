
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

@immutable
class NamedConstant extends Expression {

  final String name;

  const NamedConstant(this.name);

  @override
  List<Expression> getChildren() {
    return [];
  }

  @override
  Expression deepClone() {
    return NamedConstant(name);
  }

  @override
  Expression deepCloneWithChildren(List<Expression> newChildren) {
    return NamedConstant(name);
  }

  @override
  Expression getNormalized() {
    return this;
  }

  @override
  bool get isConstant => true;

  @override
  int compareTo(other) {
    if (!(other is NamedConstant)) {
      return compareToClass(other);
    }
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return 'NamedConstant($name)';
  }

}
