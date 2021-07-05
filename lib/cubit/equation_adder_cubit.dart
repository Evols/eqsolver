
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'equation_adder_state.dart';

class EquationAdderCubit extends Cubit<EquationAdderState> {
  
  EquationAdderCubit() : super(EquationAdderState(''));

  void updateEq(String tempEq) => emit(EquationAdderState(tempEq));

  void validate() {

  }
}
