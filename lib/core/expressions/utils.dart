
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/gcd.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/core/expressions/named_constant.dart';
import 'package:formula_transformator/core/expressions/variable.dart';

int getExpressionClassId(Expression val) {
  if (val is LiteralConstant) {
    return 1;
  }
  if (val is NamedConstant) {
    return 2;
  }
  if (val is Variable) {
    return 3;
  }
  if (val is Addition) {
    return 4;
  }
  if (val is Multiplication) {
    return 5;
  }
  if (val is Gcd) {
    return 6;
  }
  return 0;
}
