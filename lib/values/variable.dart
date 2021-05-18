
import 'package:formula_transformator/values/value.dart';

class Variable extends Value {

  final String id;

  const Variable(this.id);

  @override
  List<Value> getChildren() {
    return [];
  }

  @override
  Value deepClone() {
    return Variable(id);
  }
}
