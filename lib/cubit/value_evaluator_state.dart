
part of 'value_evaluator_cubit.dart';

@immutable
class ValueEvaluatorState {

  final Map<String, BigInt> variableValues;
  final Map<String, BigInt> constantValues;

  ValueEvaluatorState(this.variableValues, this.constantValues);

}
