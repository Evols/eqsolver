
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

  @override
  int compareTo(other) {
    if (!(other is Addition)) {
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
