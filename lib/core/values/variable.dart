
import 'package:formula_transformator/core/values/value.dart';

class Variable extends Value {

  final String name;

  const Variable(this.name);

  @override
  List<Value> getChildren() {
    return [];
  }

  @override
  Value deepClone() {
    return Variable(name);
  }

  @override
  Value deepCloneWithChildren(List<Value> newChildren) {
    return Variable(name);
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
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return 'Variable($name)';
  }

}
