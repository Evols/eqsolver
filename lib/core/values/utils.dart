
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/core/values/variable.dart';

int getValueClassId(Value val) {
  if (val is Constant) {
    return 1;
  }
  if (val is Variable) {
    return 2;
  }
  if (val is Addition) {
    return 3;
  }
  if (val is Multiplication) {
    return 4;
  }
  return 0;
}
