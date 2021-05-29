
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/core/expressions/variable.dart';

int getExpressionClassId(Expression val) {
  if (val is LiteralConstant) {
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
