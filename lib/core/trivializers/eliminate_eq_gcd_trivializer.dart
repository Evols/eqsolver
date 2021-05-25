
import 'package:formula_transformator/core/trivializers/trivializer.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/utils.dart';
import 'package:formula_transformator/extensions.dart';

class EliminateEqGcdTrivializer implements Trivializer {

  const EliminateEqGcdTrivializer();

  @override
  Value? transform(Value value, [bool isEquation = false]) {

    if (isEquation && value is Addition) {

      // The constant part of each term
      final constantParts = value.terms.map<int>(
        (term) {
          if (term is Constant) {
            return term.number;
          }
          if (term is Multiplication) {
            return term.factors.fold<int>(
              1,
              (factorAcc, factor) => factorAcc * (factor is Constant ? factor.number : 1),
            );
          }
          return 1;
        }
      ).toList();

      final gcd = 
      // Compute the gcd of all terms
      constantParts.fold<int>(
        0,
        (gcdAcc, term) => computeGcd(term, gcdAcc)
      )
      // And if all terms are negative, make it negative
      * (constantParts.where(
        (element) => element >= 0
      ).isEmpty ? -1 : 1);

      if (gcd > 1 || gcd < 0) {
        final newTerms = value.terms.mapIndexed(
          (term, index) {
            if (term is Constant) {
              return Constant(term.number ~/ gcd);
            }
            if (term is Multiplication) {
              final constantPart = term.factors.fold<int>(
                1,
                (factorAcc, factor) => factorAcc * (factor is Constant ? factor.number : 1),
              );
              final nonConstantPart = term.factors.where((element) => !(element is Constant));
              return Multiplication([
                Constant(constantPart ~/ gcd),
                ...nonConstantPart,
              ]);
            }
            throw UnsupportedError('Internal error in EliminateEqGcdTrivializer');
          },
        ).toList();

        return Addition(newTerms);
      }

      // final newChildren = value.children.where((element) => !(element is Constant)).toList();
      // if (newChildren.length != value.children.length) {
      //   return Multiplication(newChildren);
      // }
    }
    return null;
  }

}
