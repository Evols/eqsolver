
import 'package:formula_transformator/transformators/transformator.dart';
import 'package:formula_transformator/values/constant.dart';
import 'package:formula_transformator/values/multiplication.dart';
import 'package:formula_transformator/values/value.dart';

class MultZeroTrivializer implements Transformator {

  @override
  List<Value> transform(Value value) {
    if (value is Multiplication) {
      final newChildren = value.children.where((child) => child is Constant && child.number == 0.0);
      if (newChildren.isNotEmpty) {
        return [ Constant(0.0) ];
      }
    }
    return [];
  }

}
