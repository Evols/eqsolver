
import 'package:formula_transformator/core/expressions/expression.dart';

abstract class Trivializer {
  Expression? transform(Expression expression, [bool isEquation = false]);

  const Trivializer();
}
