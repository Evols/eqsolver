
import 'package:formula_transformator/values/value.dart';

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
  int compareTo(other) {
    if (!(other is Multiplication)) {
      return compareToClass(other);
    }
    if (other.children.length != children.length) {
      return other.children.compareTo(children.length);
    }
    for (var i = 0; i < children.length; i++) {
      final comp = other.children[i].compareTo(children[i]);
      if (comp != 0) {
        return comp;
      }
    }
    return 0;
  }
}
