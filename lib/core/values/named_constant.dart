
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/values/value.dart';

@immutable
class NamedConstant extends Value {

  final String name;

  const NamedConstant(this.name);

  @override
  List<Value> getChildren() {
    return [];
  }

  @override
  Value deepClone() {
    return NamedConstant(name);
  }

  @override
  Value deepCloneWithChildren(List<Value> newChildren) {
    return NamedConstant(name);
  }

  @override
  Value getNormalized() {
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
