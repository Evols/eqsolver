
import 'package:formula_transformator/core/values/value.dart';

import '../utils.dart';

class Multiplication extends Value {

  final List<Value> factors;

  const Multiplication(this.factors);

  @override
  List<Value> getChildren() {
    return factors;
  }

  @override
  Value deepClone() {
    return Multiplication(factors.map((e) => e.deepClone()).toList());
  }

  @override
  Value deepCloneWithChildren(List<Value> newChildren) {
    return Multiplication(newChildren);
  }

  @override
  Value getNormalized() {
    final childrenNormalized = factors.map((e) => e.getNormalized()).toList();
    childrenNormalized.sort();
    return Multiplication(childrenNormalized);
  }

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
