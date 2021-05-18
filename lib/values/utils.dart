
import 'package:formula_transformator/values/addition.dart';
import 'package:formula_transformator/values/constant.dart';
import 'package:formula_transformator/values/multiplication.dart';
import 'package:formula_transformator/values/value.dart';
import 'package:formula_transformator/values/variable.dart';

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
