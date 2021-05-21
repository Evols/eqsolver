
import 'package:bloc/bloc.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:meta/meta.dart';

part 'equations_state.dart';

class EquationsCubit extends Cubit<EquationsState> {

  EquationsCubit(List<Value> equations) : super(EquationsState(equations));

  void addEquations(List<Value> equations) {
    print('addEquations: $equations');
    emit(EquationsState([ ...state.equations, ...equations ]));
  }

}
