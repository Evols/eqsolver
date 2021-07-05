
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:math_expressions/math_expressions.dart' as MathExp;

Equation parse(String string) => applyTrivializersToEq(
  Equation.fromParts(
    string.split('=').map(
      (e) => MathExp.Parser().parse(e)
    ).map(
      (e) => mathExpToFt(e)
    ).toList()
  )
);

Expression mathExpToFt(MathExp.Expression mathExp) {
  if (mathExp is MathExp.Plus) {
    return Addition([
      mathExpToFt(mathExp.first),
      mathExpToFt(mathExp.second),
    ]);
  }
  if (mathExp is MathExp.Minus) {
    return Addition([
      mathExpToFt(mathExp.first),
      Multiplication([
        LiteralConstant(BigInt.from(-1)),
        mathExpToFt(mathExp.second),
      ]),
    ]);
  }
  if (mathExp is MathExp.Times) {
    return Multiplication([
      mathExpToFt(mathExp.first),
      mathExpToFt(mathExp.second),
    ]);
  }
  if (mathExp is MathExp.Number) {
    return LiteralConstant(BigInt.from(mathExp.value));
  }
  if (mathExp is MathExp.Variable) {
    return Variable(mathExp.name);
  }
  throw Exception('Unable to use the parsed expression');
}
