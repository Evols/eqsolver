
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_transformators/equation_transformator.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/named_constant.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:formula_transformator/utils.dart';

@immutable
class DiophTransformator extends EquationTransformator {

  final Addition selectedAddition;

  DiophTransformator(this.selectedAddition);

  static int solvingIdx = 1;

  @override
  List<Equation> transformEquationImpl(Equation equation) {

    // a*u+b*v=c

    final lhs = equation.leftPart;
    final rhs = equation.rightPart;

    if (!(lhs is Addition) || !identical(selectedAddition, lhs) || lhs.terms.length != 2) {
      return [];
    }

    // a ; b
    final literalConstantParts = lhs.terms.map(
      (multiplication) => (multiplication as Multiplication).factors.fold<BigInt>(
        BigInt.from(1),
        (previousValue, factor) => factor is LiteralConstant ? previousValue * factor.number : previousValue,
      )
    ).toList();

    final nonLiteralConstantParts = lhs.terms.map(
      (multiplication) => (multiplication as Multiplication).factors.where(
        (factor) => factor.isConstant && !(factor is LiteralConstant)
      ).toList()
    ).toList();

    // u ; v
    final variableParts = lhs.terms.map(
      (multiplication) => (multiplication as Multiplication).factors.where(
        (child) => !child.isConstant
      ).toList()
    ).toList();

    final aLiteral = literalConstantParts[0];
    final aNonLiteral = nonLiteralConstantParts[0];
    final uFactors = variableParts[0];

    final bLiteral = literalConstantParts[1];
    final bNonLiteral = nonLiteralConstantParts[1];
    final vFactors = variableParts[1];

    var u0ref = Ref<BigInt>(BigInt.from(0)), v0ref = Ref<BigInt>(BigInt.from(0));
    final gcd = extEuclidAlgo(aLiteral, bLiteral, u0ref, v0ref);
    final u0 = u0ref.value, v0 = v0ref.value;

    if (gcd != BigInt.from(1)) {
      print('GCD WAS $gcd. TODO: handle this case. ABORTING');
      return [];
    }

    // a*u+b*v=c

    // a*u0+b*v0=1 (ez)
    // a*(c*u0)+b*(c*v0)=c
    // a*(c*u0+b*k)+b*(c*v0-a*k)=c
    // u=c*u0+b*k ; v=c*v0-a*k
    // c*u0+b*k-u=0 ; c*v0-a*k-v=0

    // a*u0+b*v0=pgcd(a,b) (hard)
    // d*pgcd(a,b)=c
    // a*(d*u0)+b*(d*v0)=c
    // a*(d*u0+b*k)+b*(d*v0-a*k)=c
    // u=d*u0+b*k ; v=d*v0-a*k

    final varId = 'k_$solvingIdx';
    final uId = 'u_$solvingIdx';
    final vId = 'v_$solvingIdx';
    solvingIdx++;

    final abAreLiteral = aNonLiteral.isEmpty && bNonLiteral.isEmpty;

    return [
      ...(
        abAreLiteral
        ? []
        : [
          Equation(
            Addition([
              Multiplication([
                LiteralConstant(aLiteral),
                ...aNonLiteral,
                NamedConstant(uId),
              ]),
              Multiplication([
                LiteralConstant(bLiteral),
                ...bNonLiteral,
                NamedConstant(vId),
              ]),
            ]),
            LiteralConstant(BigInt.from(1))
          )
        ]
      ),
      Equation(
        Multiplication(uFactors),
        Addition([
          Multiplication([
            rhs,
            (
              abAreLiteral
              ? LiteralConstant(u0)
              : NamedConstant(uId)
            ),
          ]),
          Multiplication([
            LiteralConstant(-bLiteral),
            ...bNonLiteral,
            Variable(varId),
          ]),
        ]),
      ),
      Equation(
        Multiplication(vFactors),
        Addition([
          Multiplication([
            rhs,
            (
              abAreLiteral
              ? LiteralConstant(v0)
              : NamedConstant(vId)
            ),
          ]),
          Multiplication([
            LiteralConstant(aLiteral),
            ...aNonLiteral,
            Variable(varId),
          ]),
        ]),
      ),
    ];
  }

}
