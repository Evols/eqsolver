
import 'package:bloc/bloc.dart';
import 'package:formula_transformator/core/equation_solvers/solutions.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:meta/meta.dart';

part 'value_evaluator_state.dart';

class ValueEvaluatorCubit extends Cubit<ValueEvaluatorState> {

  final EquationsCubit equationsCubit;

  ValueEvaluatorCubit(this.equationsCubit) : super(ValueEvaluatorState(Solutions()));

  void setVariableValue(String varId, BigInt value) => emit(ValueEvaluatorState(Solutions(state.solutions.constants, { ...state.solutions.variables, varId: value })));

  void unsetVariableValue(String varId) {
    final newVariables = { ...state.solutions.variables };
    newVariables.removeWhere((key, value) => key == varId);
    emit(ValueEvaluatorState(Solutions(state.solutions.constants, newVariables)));
  }

  void setConstantValue(String constId, BigInt value) => emit(ValueEvaluatorState(Solutions({ ...state.solutions.constants, constId: value }, state.solutions.variables)));

  void unsetConstantValue(String constId) {
    final newConstants = { ...state.solutions.constants };
    newConstants.removeWhere((key, value) => key == constId);
    emit(ValueEvaluatorState(Solutions(newConstants, state.solutions.variables)));
  }

}
