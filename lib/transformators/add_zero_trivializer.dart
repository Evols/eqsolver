
import 'package:formula_transformator/transformators/transformator.dart';
import 'package:formula_transformator/values/addition.dart';
import 'package:formula_transformator/values/constant.dart';
import 'package:formula_transformator/values/value.dart';

class AddZeroTrivializer implements Transformator {

  @override
  List<Value> transform(Value value) {
    if (value is Addition) {
      final newChildren = value.children.where((child) => !(child is Constant && child.number == 0.0)).toList();
      if (newChildren.length != value.children.length) {
        return [ Addition(newChildren) ];
      }
    }
    return [];
  }

}
