
import 'package:formula_transformator/values/value.dart';

class Constant extends Value {

  final double number;

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
  bool isEqualTo(Value other) {
    return other is Constant && other.number == number;
  }

  @override
  int compareTo(other) {
    if (!(other is Constant)) {
      return compareToClass(other);
    }
    return other.number.compareTo(number);
  }

}
