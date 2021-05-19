
import 'package:formula_transformator/core/values/value.dart';

import '../utils.dart';

class Addition extends Value {

  final List<Value> children;

  const Addition(this.children);

  @override
  List<Value> getChildren() {
    return children;
  }

  @override
  Value deepClone() {
    return Addition(children.map((e) => e.deepClone()).toList());
  }

  @override
  Value deepCloneWithChildren(List<Value> newChildren) {
    return Addition(newChildren);
  }

  @override
  Value getNormalized() {
    final childrenNormalized = children.map((e) => e.getNormalized()).toList();
    childrenNormalized.sort();
    return Addition(childrenNormalized);
  }

  @override
  int compareTo(other) {
    if (!(other is Addition)) {
      return compareToClass(other);
    }
    return compareLists(children, other.children);
  }

  @override
  String toString() {
    return 'Addition( ${children.map((e) => e.toString()).toList().join(', ')} )';
  }

}
