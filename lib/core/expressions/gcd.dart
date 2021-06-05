
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/expressions/expression.dart';

import '../utils.dart';

@immutable
class Gcd extends Expression {

  final List<Expression> args;

  const Gcd(this.args);

  @override
  List<Expression> getChildren() => args;

  @override
  Expression deepClone() => Gcd(args.map((e) => e.deepClone()).toList());

  @override
  Expression deepCloneWithChildren(List<Expression> newChildren) => Gcd(newChildren);

  @override
  Expression getNormalized() {
    final childrenNormalized = args.map((e) => e.getNormalized()).toList();
    childrenNormalized.sort();
    return Gcd(childrenNormalized);
  }

  @override
  bool get isConstant => args.where((term) => !term.isConstant).isEmpty;

  @override
  int compareTo(other) {
    if (!(other is Gcd)) {
      return compareToClass(other);
    }
    return compareLists(args, other.args);
  }

  @override
  String toString() {
    return 'Gcd( ${args.map((e) => e.toString()).toList().join(', ')} )';
  }

}
