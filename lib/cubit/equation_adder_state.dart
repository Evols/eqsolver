
part of 'equation_adder_cubit.dart';

@immutable
abstract class EquationAdderState {
  EquationAdderState();
}

class EquationAdderTextfield extends EquationAdderState {
  final String content;

  EquationAdderTextfield(this.content);
}

class EquationAdderValidating extends EquationAdderState {
  final Equation equation;
  final Map<String, AlphaExprType> computedAlphaExprTypes;
  final Map<String, AlphaExprType> editedAlphaExprTypes;

  EquationAdderValidating(this.equation, this.computedAlphaExprTypes, this.editedAlphaExprTypes);
}
