
import 'package:bloc/bloc.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:meta/meta.dart';

part 'equations_state.dart';

class EquationsCubit extends Cubit<EquationsState> {

  EquationsCubit(List<Value> equations) : super(EquationsState(equations, false));

  void addEquations(List<Value> equations) {
    final trivialized = equations.map((e) => applyTrivializers(e, true)).toList();
    print('Adding equations $trivialized');

    emit(EquationsState([ ...state.equations, ...trivialized ], state.prettifyEquations));
  }

  void setPrettifyEquations(bool prettify) {
    emit(EquationsState(state.equations, prettify));
  }

}
