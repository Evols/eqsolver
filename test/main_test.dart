
import 'package:flutter_test/flutter_test.dart';
import 'package:formula_transformator/core/equation_solvers/utils.dart';
import 'package:formula_transformator/core/expression_transformators/develop_transformator.dart';
import 'package:formula_transformator/core/expression_transformators/factorize_transformator.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/named_constant.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:formula_transformator/core/trivializers/constant_computation_trivializer.dart';
import 'package:formula_transformator/core/trivializers/empty_trivializer.dart';
import 'package:formula_transformator/core/trivializers/single_child_trivializer.dart';
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/utils.dart';
import 'package:formula_transformator/cubit/editors/equation_editor_factorize.dart';
import 'package:tuple/tuple.dart';

import 'utils.dart';

const varNames = [ 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' ];

final solutionSets = <Map<String, BigInt>>[]
..add(
  varNames.asMap().map(
    (idx, varName) => MapEntry(varName, BigInt.from(primes[idx]))
  )
)
..add(
  varNames.asMap().map(
    (idx, varName) => MapEntry(varName, BigInt.from(primes[100 + 10 * idx]))
  )
)
..add(
  varNames.asMap().map(
    (idx, varName) => MapEntry(varName, BigInt.from(primes[105 + 7 * idx]))
  )
)
..add(
  varNames.asMap().map(
    (idx, varName) => MapEntry(varName, BigInt.from(primes[51 + 11 * idx]))
  )
)
..add(
  varNames.asMap().map(
    (idx, varName) => MapEntry(varName, BigInt.from(primes[13 + 17 * idx]))
  )
)
;

const trivializers = <Trivializer>{
  ConstantComputationTrivializer(),
  SingleChildTrivializer(),
  EmptyTrivializer(),
};

Expression applyConstantLitteralsTrivializers(Expression expression, [bool isEquation = false]) {
  var tempExpression = expression;
  var applied = true;
  while (applied) {
    applied = false;
    for (var trivializer in trivializers) {
      var transformed = mountExpressionAt(tempExpression, (elem, depth) => trivializer.transform(elem, depth == 0 && isEquation));
      if (transformed != null) {
        tempExpression = transformed;
        applied = true;
        break;
      }
    }
  }
  return tempExpression;
}

void compareExpressionsWithValues(Expression exp1, Expression exp2) {
  for (var solutionSet in solutionSets) {
    final exp1inject = applyConstantLitteralsTrivializers(injectVarSolutionsExpression(exp1, solutionSet));
    final exp2inject = applyConstantLitteralsTrivializers(injectVarSolutionsExpression(exp2, solutionSet));
    expect(exp1inject, equals(exp2inject));
  }
}

void main() {

  test('Test value trivializers', () {

    final expression = Addition([
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

    final result = applyTrivializers(expression);
    final expected = Addition([
      Variable('y'),
      Variable('x'),
      LiteralConstant(BigInt.from(20)),
    ]);

    expect(result, equals(expected));

    compareExpressionsWithValues(expression, result);

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

    final results = DevelopTransformator([term2, term3]).transformExpression(expression).map((e) => applyTrivializers((e))).toList();
    expect(results.length, equals(1));

    final result = results.first;
    final expected = Addition([
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
    ]);

    expect(result, equals(expected));

    compareExpressionsWithValues(expression, result);

  });

  test('Test factorization editor', () {

    // EquationEditorFactorize.computeCardinality
    {
      final result = EquationEditorFactorize.computeCardinality([
        const Variable('x'),
        const Addition([ const NamedConstant('a'), const NamedConstant('b'), ]),
        const Variable('y'),
        const Addition([ const NamedConstant('a'), const NamedConstant('b'), ]),
        const Variable('x'),
        const Addition([const NamedConstant('a'), const NamedConstant('b'), ]),
      ]);
      expect(result, equals([
        Tuple2(const Variable('y'), 1),
        Tuple2(const Variable('x'), 2),
        Tuple2(const Addition([const NamedConstant('a'), const NamedConstant('b'), ]), 3),
      ]));
    }

    // EquationEditorFactorize.getCommonFactors
    {
      final result = EquationEditorFactorize.getCommonFactors([
        [
          LiteralConstant(BigInt.from(-5*7*13)),
          const NamedConstant('a'),
          const NamedConstant('a'),
          const Variable('y'),
        ],
        [
          LiteralConstant(BigInt.from(-5*7)),
          const NamedConstant('a'),
          const NamedConstant('a'),
          const Variable('y'),
          const Variable('y'),
          const Variable('x'),
        ],
        [
          LiteralConstant(BigInt.from(-7*13)),
          const NamedConstant('a'),
          const NamedConstant('a'),
          const NamedConstant('b'),
          const Variable('y'),
          const Variable('x'),
          const Variable('z'),
        ],
      ]);
      expect(result, equals([
        LiteralConstant(BigInt.from(-7)),
        NamedConstant('a'),
        NamedConstant('a'),
        Variable('y'),
      ]));
    }
  });

  test('Test factorization', () {

    // final term1 = Multiplication([ LiteralConstant(BigInt.from(50)), Variable('x') ]);
    // final term2 = Multiplication([ LiteralConstant(BigInt.from(10)), Variable('x'), Variable('y') ]);
    // final term3 = Variable('x');
    // final term4 = Variable('z');

    // final expression = Multiplication([
    //   LiteralConstant(BigInt.from(10)),
    //   Variable('y'),
    //   Addition([
    //     term1,
    //     term2,
    //     term3,
    //     term4,
    //   ])
    // ]);

    // final results = FactorizeTransformator([Variable('x')], [term1, term2, term3]).transformExpression(expression).map(
    //   (e) => applyTrivializers(e)
    // ).toList();
    // print('results: $results');
    // expect(results.length, equals(1));

    // final result = results.first;
    // print('result: $result');
    // // final expected = Addition([
    // //   Multiplication([
    // //     LiteralConstant(BigInt.from(10)),
    // //     Variable('y'),
    // //     Variable('t'),
    // //     Variable('w'),
    // //   ]),
    // //   Multiplication([
    // //     LiteralConstant(BigInt.from(10)),
    // //     Variable('y'),
    // //     Variable('y'),
    // //   ]),
    // //   Multiplication([
    // //     LiteralConstant(BigInt.from(10)),
    // //     Variable('y'),
    // //     Addition([
    // //       Multiplication([
    // //         LiteralConstant(BigInt.from(50)),
    // //         Variable('x'),
    // //       ]),
    // //       Variable('z'),
    // //     ]),
    // //   ])
    // // ]);

    // // expect(result, equals(expected));

    // // compareExpressionsWithValues(result, expected);

  });

}
