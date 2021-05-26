
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_transformators/equation_transformator.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/core/values/variable.dart';
import 'package:formula_transformator/utils.dart';

class DiophTransformator extends EquationTransformator {

  final List<Value> termsToFactor;

  DiophTransformator(this.termsToFactor);

  static int gcdIdx = 1;

  @override
  List<Equation> transformEquationImpl(Equation equation) {

    // a*u+b*v=c

    final lhs = equation.leftPart;
    final rhs = equation.rightPart;

    if (!(lhs is Addition)) {
      return [];
    }

    // a*u ; b*v
    final multiplicationsToDioph = lhs.terms.where(
      (multiplication) => multiplication is Multiplication && termsToFactor.where(
        (termToFactor) => identical(multiplication, termToFactor)
      ).isNotEmpty
    ).map(
      (multiplication) => multiplication as Multiplication
    ).toList();

    if (multiplicationsToDioph.length != 2) {
      return [];
    }

    // a ; b
    final constantParts = multiplicationsToDioph.map(
      (multiplication) => multiplication.factors.fold<int>(
        1,
        (previousValue, element) => element is Constant ? previousValue * element.number : previousValue,
      )
    ).toList();

    // u ; v
    final variableParts = multiplicationsToDioph.map(
      (multiplication) => multiplication.factors.where((child) => !(child is Constant)).toList()
    ).toList();

    final a = constantParts[0];
    final uFactors = variableParts[0];

    final b = constantParts[1];
    final vFactors = variableParts[1];

    var u0ref = Ref<int>(0), v0ref = Ref<int>(0);
    final gcd = extEuclidAlgo(a, b, u0ref, v0ref);
    final u0 = u0ref.value, v0 = u0ref.value;

    if (gcd != 1) {
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

    final varId = 'k_$gcdIdx';
    gcdIdx++;

    return [
      Equation(
        Multiplication(uFactors),
        Addition([
          Multiplication([
            rhs,
            Constant(u0),
          ]),
          Multiplication([
            Constant(-b),
            Variable(varId),
          ]),
        ]),
      ),
      Equation(
        Multiplication(vFactors),
        Addition([
          Multiplication([
            rhs,
            Constant(v0),
          ]),
          Multiplication([
            Constant(a),
            Variable(varId),
          ]),
        ]),
      ),
    ];
  }

}
