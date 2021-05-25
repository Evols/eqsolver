
import 'package:formula_transformator/core/transformators/transformator.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/core/values/variable.dart';
import 'package:formula_transformator/utils.dart';

class DiophTransformator extends Transformator {

  final List<Value> termsToFactor;

  DiophTransformator(this.termsToFactor);

  static int gcdIdx = 1;

  @override
  List<Value> transform(Value value) {

    if (!(value is Addition) || value.terms.length < 3) {
      return [];
    }

    final multiplicationsToDioph = value.terms.where(
      (multiplication) => multiplication is Multiplication && termsToFactor.where(
        (termToFactor) => identical(multiplication, termToFactor)
      ).isNotEmpty
    ).map(
      (multiplication) => multiplication as Multiplication
    ).toList();

    if (multiplicationsToDioph.length != 2) {
      return [];
    }

    // a*u+b*v=c

    final constantParts = multiplicationsToDioph.map(
      (multiplication) => multiplication.factors.fold<int>(
        1,
        (previousValue, element) => element is Constant ? previousValue * element.number : previousValue,
      )
    ).toList();

    final variableParts = multiplicationsToDioph.map(
      (multiplication) => multiplication.factors.where((child) => !(child is Constant)).toList()
    ).toList();

    final a = constantParts[0];
    final uFactors = variableParts[0];

    final b = constantParts[1];
    final vFactors = variableParts[1];

    final cTerms = value.terms.where(
      (term) => multiplicationsToDioph.where(
        (termToFactor) => identical(term, termToFactor)
      ).isEmpty
    ).toList();

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
      // c*u0+b*k-u=0
      Addition([
        // c*u0
        Multiplication([
          Constant(u0),
          Addition(cTerms),
        ]),
        // b*k
        Multiplication([
          Constant(b),
          Variable(varId),
        ]),
        // -u
        Multiplication([
          Constant(-1),
          ...uFactors,
        ]),
      ]),
      // c*v0-a*k-v=0
      Addition([
        // c*v0
        Multiplication([
          Constant(v0),
          Addition(cTerms),
        ]),
        // -a*k
        Multiplication([
          Constant(-a),
          Variable(varId),
        ]),
        // -v
        Multiplication([
          Constant(-1),
          ...vFactors,
        ]),
      ]),
    ].map((e) => applyTrivializers(e)).toList();
  }

}
