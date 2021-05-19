
import 'package:formula_transformator/values/value.dart';

import '../utils.dart';

class Multiplication extends Value {

  final List<Value> children;

  const Multiplication(this.children);

  @override
  List<Value> getChildren() {
    return children;
  }

  @override
  Value deepClone() {
    return Multiplication(children.map((e) => e.deepClone()).toList());
  }

  @override
  Value deepCloneWithChildren(List<Value> newChildren) {
    return Multiplication(newChildren);
  }

  @override
  Value getNormalized() {
    final childrenNormalized = children.map((e) => e.getNormalized()).toList();
    childrenNormalized.sort();
    return Multiplication(childrenNormalized);
  }

  @override
  int compareTo(other) {
    if (!(other is Multiplication)) {
      return compareToClass(other);
    }
    return compareLists(children, other.children);
  }

  @override
  String toString() {
    return 'Multiplication( ${children.map((e) => e.toString()).toList().join(', ')} )';
  }

}
