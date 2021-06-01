
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_transformators/equation_transformator.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:tuple/tuple.dart';

@immutable
class Delta2ndDegTransformator extends EquationTransformator {

  final String varId;

  Delta2ndDegTransformator(this.varId);

  static int solvingIdx = 1;

  @override
  List<Equation> transformEquationImpl(Equation equation) {

    final lhs = equation.leftPart, rhs = equation.rightPart;
    if (!(rhs is LiteralConstant && rhs.number == BigInt.zero)) {
      return [];
    }

    final termsDegs = (lhs is Addition ? lhs.terms : [lhs]).map(
      (term) => Tuple2(
        Multiplication((term is Multiplication ? term.factors : [term]).where(
          (factor) => !(factor is Variable && factor.name == varId)
        ).toList()),
        (term is Multiplication ? term.factors : [term]).fold<int>(
          0,
          (degree, factor) => factor is Variable && factor.name == varId ? degree + 1 : degree,
        ),
      )
    ).toList();

    final termsByDegs = termsDegs.fold<Map<int, List<Expression>>>(
      <int, List<Expression>>{},
      (acc, value) {
        final withDeg = acc..putIfAbsent(value.item2, () => []);
        withDeg[value.item2]!.add(value.item1);
        return withDeg;
      }
    );

    print('termsDegs: $termsDegs');
    print('termsByDegs: $termsByDegs');

    if (!termsByDegs.containsKey(2)) {
      return [];
    }

    final deltaVarId = '\delta_$solvingIdx';
    solvingIdx++;

    final a = Addition(termsByDegs[0] ?? []);
    final b = Addition(termsByDegs[1] ?? []);
    final c = Addition(termsByDegs[2] ?? []);

    return [
      Equation(
        Variable(deltaVarId),
        Addition([
          Multiplication([ b, b ]),
          Multiplication([ LiteralConstant(BigInt.from(-4)), a, c ]),
        ]),
      ),
    ];
  }

}
