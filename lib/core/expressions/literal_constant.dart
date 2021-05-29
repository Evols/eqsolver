
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

@immutable
class LiteralConstant extends Expression {

  final BigInt number;

  const LiteralConstant(this.number);

  @override
  List<Expression> getChildren() {
    return [];
  }

  @override
  Expression deepClone() {
    return LiteralConstant(number);
  }

  @override
  Expression deepCloneWithChildren(List<Expression> newChildren) {
    return LiteralConstant(number);
  }

  @override
  Expression getNormalized() {
    return this;
  }

  @override
  bool get isConstant => true;

  @override
  int compareTo(other) {
    if (!(other is LiteralConstant)) {
      return compareToClass(other);
    }
    return number.compareTo(other.number);
  }

  @override
  String toString() {
    return 'LiteralConstant($number)';
  }
}
