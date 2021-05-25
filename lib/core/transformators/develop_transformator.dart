
import 'package:formula_transformator/core/transformators/transformator.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';

class DevelopTransformator extends Transformator {

  final List<Value> termsToDevelop;

  DevelopTransformator(this.termsToDevelop);

  @override
  List<Value> transform(Value value) {

    if (!(value is Multiplication) || value.factors.length < 2) {
      return [];
    }

    final additions = value.factors.where(
      (factor) => factor is Addition && factor.terms.where(
        (term) => termsToDevelop.where(
          (term2) => identical(term, term2)
        ).isNotEmpty
      ).length == termsToDevelop.length
    ).toList();

    if (additions.isEmpty) {
      return [];
    }

    final addition = additions[0];
    final otherFactors = value.factors.where((element) => !identical(element, addition)).toList();

    final termsToNotDevelop = addition.getChildren().where(
      (term) => termsToDevelop.where(
        (termToDevelop) => identical(term, termToDevelop)
      ).isEmpty
    ).toList();

    return [
      applyTrivializers(Addition([
        ...termsToDevelop.map((termToDevelop) => Multiplication([
          ...otherFactors,
          termToDevelop,
        ])).toList(),
        Multiplication([
          ...otherFactors,
          Addition(termsToNotDevelop),
        ]),
      ])),
    ];
  }

}
