
import 'package:formula_transformator/core/expressions/expression.dart';

abstract class ExpressionTransformator {
  List<Expression> transformExpression(Expression expression);
}
