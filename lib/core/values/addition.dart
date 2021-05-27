
import 'package:formula_transformator/core/values/value.dart';

import '../utils.dart';

class Addition extends Value {

  final List<Value> terms;

  const Addition(this.terms);

  @override
  List<Value> getChildren() {
    return terms;
  }

  @override
  Value deepClone() {
    return Addition(terms.map((e) => e.deepClone()).toList());
  }

  @override
  Value deepCloneWithChildren(List<Value> newChildren) {
    return Addition(newChildren);
  }

  @override
  Value getNormalized() {
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
