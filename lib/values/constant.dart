
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
}