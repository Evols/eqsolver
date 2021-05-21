
import 'package:bloc/bloc.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:meta/meta.dart';

part 'equations_state.dart';

class EquationsCubit extends Cubit<EquationsState> {

  EquationsCubit(List<Value> equations) : super(EquationsState(equations));

  void addEquations(List<Value> equations) {
    final trivialized = equations.map((e) => applyTrivializers(e)).toList();
    print('Addition equations $trivialized');

    emit(EquationsState([ ...state.equations, ...trivialized ]));
  }

}
