
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/equation_transformators/equation_transformator.dart';
import 'package:formula_transformator/core/values/value.dart';

class ReorganizeTransformator extends EquationTransformator {

  final List<Value> selectedTerms;

  ReorganizeTransformator(this.selectedTerms);

  @override
  List<Equation> transformEquationImpl(Equation equation) {
    // TODO
    return [];
  }

}
