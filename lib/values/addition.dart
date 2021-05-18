
import 'package:formula_transformator/values/value.dart';

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
}
