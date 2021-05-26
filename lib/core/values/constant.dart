
import 'package:formula_transformator/core/values/value.dart';

class Constant extends Value {

  final BigInt number;

  const Constant(this.number);

  @override
  List<Value> getChildren() {
    return [];
  }

  @override
  Value deepClone() {
    return Constant(number);
  }

  @override
  Value deepCloneWithChildren(List<Value> newChildren) {
    return Constant(number);
  }

  @override
  Value getNormalized() {
    return this;
  }

  @override
  int compareTo(other) {
    if (!(other is Constant)) {
      return compareToClass(other);
    }
    return number.compareTo(other.number);
  }

  @override
  String toString() {
    return 'Constant($number)';
  }
}
