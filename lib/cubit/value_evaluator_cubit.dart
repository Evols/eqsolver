
import 'package:bloc/bloc.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:meta/meta.dart';

part 'value_evaluator_state.dart';

class ValueEvaluatorCubit extends Cubit<ValueEvaluatorState> {

  final EquationsCubit equationsCubit;

  ValueEvaluatorCubit(this.equationsCubit) : super(ValueEvaluatorState({}));

  void setValue(String varId, BigInt value) => emit(ValueEvaluatorState({ ...state.values, varId: value }));

  void unsetValue(String varId) {
    final newMap = { ...state.values };
    newMap.removeWhere((key, value) => key == varId);
    emit(ValueEvaluatorState(newMap));
  }

}
