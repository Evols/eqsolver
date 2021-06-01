
import 'package:flutter_test/flutter_test.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/expression_transformators/develop_transformator.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';

void main() {

  test('Test value trivializers', () {

    final raw = Addition([
      Multiplication([
        LiteralConstant(BigInt.zero),
        Variable('z'),
      ]),
      Multiplication([]),
      Addition([]),
      Multiplication([
        Addition([
          LiteralConstant(BigInt.from(9)),
          Variable('x'),
        ]),
      ]),
      Addition([
        LiteralConstant(BigInt.from(10)),
      ]),
      Variable('y'),
    ]);

    final result = applyTrivializers(raw);

    expect(result, equals(
      Addition([
        Variable('y'),
        Variable('x'),
        LiteralConstant(BigInt.from(20)),
      ])
    ));

  });

  test('Test develop', () {

    final term1 = Multiplication([ LiteralConstant(BigInt.from(50)), Variable('x') ]);
    final term3 = Variable('y');
    final term2 = Multiplication([ Variable('t'), Variable('w') ]);
    final term4 = Variable('z');

    final expression = Multiplication([
      LiteralConstant(BigInt.from(10)),
      Variable('y'),
      Addition([
        term1,
        term2,
        term3,
        term4,
      ])
    ]);

    final result = DevelopTransformator([term2, term3]).transformExpression(expression).map((e) => applyTrivializers((e))).toList();

    expect(result, equals(
      [
        Addition([
          Multiplication([
            LiteralConstant(BigInt.from(10)),
            Variable('y'),
            Variable('t'),
            Variable('w'),
          ]),
          Multiplication([
            LiteralConstant(BigInt.from(10)),
            Variable('y'),
            Variable('y'),
          ]),
          Multiplication([
            LiteralConstant(BigInt.from(10)),
            Variable('y'),
            Addition([
              Multiplication([
                LiteralConstant(BigInt.from(50)),
                Variable('x'),
              ]),
              Variable('z'),
            ]),
          ])
        ]),
      ]
    ));

  });

}
