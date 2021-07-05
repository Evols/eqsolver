
import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

@immutable
abstract class FormulaToken {}

class ParenthesisToken extends FormulaToken {
  final bool opening;
  ParenthesisToken({ required this.opening });
}

class ParenthesisContainer extends FormulaToken {
  final List<FormulaToken> children;
  ParenthesisContainer(this.children);
}

class ExpressionToken extends FormulaToken {
  final String expression;
  ExpressionToken(this.expression);
}

class AlphaExpressionToken extends FormulaToken {
  final String expression;
  AlphaExpressionToken(this.expression);
}

class NumericExpressionToken extends FormulaToken {
  final BigInt expression;
  NumericExpressionToken(this.expression);
}

enum OperatorTokenEnum {
  Addition,
  Substraction,
  Multiplication,
}

class OperatorToken extends FormulaToken {
  final OperatorTokenEnum operator;
  OperatorToken(this.operator);
}

void tokenize(String string) {
  var tempString = string.replaceAll(' ', '');

  var tokens = <FormulaToken>[];

  final tokenizers = <Tuple2<FormulaToken, int>? Function(String)>{
    // Literal number
    (String str) {
      final match = RegExp(r'\-?[0-9]+').firstMatch(str);
      if (match != null && match.start == 0 && (tokens.isEmpty || tokens.last is OperatorToken || tokens.last is ParenthesisToken)) {
        return Tuple2(NumericExpressionToken(BigInt.parse(match.group(0)!)), match.end);
      }
    },
  };

  bool justAdded = true;
  while (justAdded) {
    justAdded = false;

  }
}
