
import 'package:bloc/bloc.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:meta/meta.dart';

part 'value_evaluator_state.dart';

class ValueEvaluatorCubit extends Cubit<ValueEvaluatorState> {

  final EquationsCubit equationsCubit;

  ValueEvaluatorCubit(this.equationsCubit) : super(ValueEvaluatorState());
}
