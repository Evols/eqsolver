
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

import '../utils.dart';

@immutable
class Multiplication extends Expression {

  final List<Expression> factors;

  const Multiplication(this.factors);

  @override
  List<Expression> getChildren() {
    return factors;
  }

  @override
  Expression deepClone() {
    return Multiplication(factors.map((e) => e.deepClone()).toList());
  }

  @override
  Expression deepCloneWithChildren(List<Expression> newChildren) {
    return Multiplication(newChildren);
  }

  @override
  Expression getNormalized() {
    final childrenNormalized = factors.map((e) => e.getNormalized()).toList();
    childrenNormalized.sort();
    return Multiplication(childrenNormalized);
  }

  @override
  bool get isConstant => factors.where((factor) => !factor.isConstant).isEmpty;

  @override
  int compareTo(other) {
    if (!(other is Multiplication)) {
      return compareToClass(other);
    }
    return compareLists(factors, other.factors);
  }

  @override
  String toString() {
    return 'Multiplication( ${factors.map((e) => e.toString()).toList().join(', ')} )';
  }

}
