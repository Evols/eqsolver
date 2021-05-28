
import 'package:formula_transformator/core/value_transformators/value_transformator.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/literal_constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

class FactorizeTransformator extends ValueTransformator {

  final List<Value> commonFactors;
  final List<Value> termsToFactor;

  FactorizeTransformator(this.commonFactors, this.termsToFactor);

  @override
  List<Value> transformValue(Value value) {

    if (!(value is Addition) || value.terms.length < 2) {
      return [];
    }

    final multiplicationsToFactor = value.terms.where(
      (multiplication) => multiplication is Multiplication && termsToFactor.where(
        (term2) => identical(multiplication, term2)
      ).isNotEmpty
    ).map(
      (multiplication) => multiplication as Multiplication
    ).toList();

    // The greatest common deminator. Will be 1 even if the returned value is 0
    final _gcd = multiplicationsToFactor.map(
      (e) => e.factors.fold<BigInt>(
        BigInt.from(1),
        (previousValue, element) => element is LiteralConstant ? previousValue * element.number : previousValue,
      )
    ).fold<BigInt>(
      BigInt.from(0),
      (previousValue, element) => element.gcd(previousValue),
    );

    final gcd = _gcd < BigInt.from(1) ? BigInt.from(1) : _gcd;

    // Factors to divide by, without the constants, that will be handled differently
    final actualFactorsToDivi = <Value>[
      ...(gcd != BigInt.from(1) ? [ LiteralConstant(gcd) ] : []),
      ...commonFactors.where((element) => !(element is LiteralConstant)),
    ];

    // The non factors parts. If we consider that we want to turn a*b+a*c+... into a*(b+c+...), this is the array of b, c, ...
    final nonFactorPartTerms = multiplicationsToFactor.map(
      (multiplication) {

        var factorsToLookForCopy = [...actualFactorsToDivi];
        var nonFactorPart = <Value>[];

        for (var multiplicationFactor in multiplication.factors) {

          var found = false;

          for (var lookedForFactorsIndex = factorsToLookForCopy.length - 1; lookedForFactorsIndex >= 0; lookedForFactorsIndex--) {
            if (!(multiplicationFactor is LiteralConstant) && multiplicationFactor.isEquivalentTo(factorsToLookForCopy[lookedForFactorsIndex])) {
              found = true;
              factorsToLookForCopy.removeAt(lookedForFactorsIndex);
              break;
            }
          }

          if (!found) {
            if (multiplicationFactor is LiteralConstant) {
              nonFactorPart.add(LiteralConstant(multiplicationFactor.number ~/ gcd));
            } else {
              nonFactorPart.add(multiplicationFactor);
            }
          }

        }

        return nonFactorPart;
      }
    );

    final termsToNotDevelop = value.terms.where(
      (candidateTerm) => termsToFactor.where(
        (termToFactor) => identical(candidateTerm, termToFactor)
      ).isEmpty
    );

    final rawResult = Addition([
      Multiplication([
        ...(gcd != BigInt.from(1) ? [ LiteralConstant(gcd) ] : []),
        ...actualFactorsToDivi,
        Addition(nonFactorPartTerms.map(
          (factors) => Multiplication(factors)
        ).toList()),
      ]),
      ...termsToNotDevelop,
    ]);

    return [
      applyTrivializers(rawResult),
    ];
  }

}
