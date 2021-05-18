
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
}
