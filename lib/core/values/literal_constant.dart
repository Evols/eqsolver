
import 'package:formula_transformator/core/values/value.dart';

class LiteralConstant extends Value {

  final BigInt number;

  const LiteralConstant(this.number);

  @override
  List<Value> getChildren() {
    return [];
  }

  @override
  Value deepClone() {
    return LiteralConstant(number);
  }

  @override
  Value deepCloneWithChildren(List<Value> newChildren) {
    return LiteralConstant(number);
  }

  @override
  Value getNormalized() {
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
