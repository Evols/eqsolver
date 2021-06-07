
import 'package:bloc/bloc.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:meta/meta.dart';

part 'value_evaluator_state.dart';

class ValueEvaluatorCubit extends Cubit<ValueEvaluatorState> {

  final EquationsCubit equationsCubit;

  ValueEvaluatorCubit(this.equationsCubit) : super(ValueEvaluatorState({}, {}));

  void setVariableValue(String varId, BigInt value) => emit(ValueEvaluatorState({ ...state.variableValues, varId: value }, state.constantValues));

  void unsetVariableValue(String varId) {
    final newMap = { ...state.variableValues };
    newMap.removeWhere((key, value) => key == varId);
    emit(ValueEvaluatorState(newMap, state.constantValues));
  }

  void setConstantValue(String constId, BigInt value) => emit(ValueEvaluatorState(state.variableValues, { ...state.constantValues, constId: value }));

  void unsetConstantValue(String constId) {
    final newMap = { ...state.constantValues };
    newMap.removeWhere((key, value) => key == constId);
    emit(ValueEvaluatorState(state.variableValues, newMap));
  }

}
