
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

import '../utils.dart';

@immutable
class Addition extends Expression {

  final List<Expression> terms;

  const Addition(this.terms);

  @override
  List<Expression> getChildren() {
    return terms;
  }

  @override
  Expression deepClone() {
    return Addition(terms.map((e) => e.deepClone()).toList());
  }

  @override
  Expression deepCloneWithChildren(List<Expression> newChildren) {
    return Addition(newChildren);
  }

  @override
  Expression getNormalized() {
    final childrenNormalized = terms.map((e) => e.getNormalized()).toList();
    childrenNormalized.sort();
    return Addition(childrenNormalized);
  }

  @override
  bool get isConstant => terms.where((term) => !term.isConstant).isEmpty;

  @override
  int compareTo(other) {
    if (!(other is Addition)) {
      return compareToClass(other);
    }
    return compareLists(terms, other.terms);
  }

  @override
  String toString() {
    return 'Addition( ${terms.map((e) => e.toString()).toList().join(', ')} )';
  }

}
