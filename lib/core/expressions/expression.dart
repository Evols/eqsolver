
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/expressions/utils.dart';

@immutable
abstract class Expression implements Comparable {

  const Expression();

  List<Expression> getChildren();
  Expression deepClone();
  Expression deepCloneWithChildren(List<Expression> newChildren);
  Expression getNormalized();
  bool get isConstant;

  int compareToClass(Expression other) {
    return getExpressionClassId(this).compareTo(getExpressionClassId(other));
  }

  bool isEquivalentTo(Expression other) {
    return getNormalized() == other.getNormalized();
  }

  @override
  // ignore: hash_and_equals
  bool operator==(Object other) {
    if (!(other is Expression)) {
      return true;
    }
    return compareTo(other) == 0;
  }

  List<Expression> whereTree(bool Function(Expression) recurser) {
    return [
      ...(recurser(this) ? [ this ] : []),
      ...getChildren().map((e) => e.whereTree(recurser)).expand((e) => e).toList(),
    ];
  }

  Expression? findTree(bool Function(Expression) recurser) {
    if (recurser(this)) {
      return this;
    }
    return getChildren().fold(null, (expression, element) => expression ?? element.findTree(recurser));
  }

  T foldTree<T>(T initialValue, T Function(T, Expression) recurser) {
    final rcsValue = recurser(initialValue, this);
    return getChildren().fold(rcsValue, (value, element) => element.foldTree<T>(value, recurser));
  }

  Expression mountAt(Expression at, Expression toMount) {
    if (identical(this, at)) {
      return toMount;
    }
    final children = getChildren();
    if (children.isEmpty) {
      return this;
    }
    return deepCloneWithChildren(children.map(
      (e) => e.mountAt(at, toMount)
    ).toList());
  }

}
