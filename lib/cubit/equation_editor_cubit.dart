
import 'package:bloc/bloc.dart';
import 'package:formula_transformator/core/transformators/develop_transformator.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/utils.dart';
import 'package:meta/meta.dart';

part 'equation_editor_state.dart';

class EquationEditorCubit extends Cubit<EquationEditorState> {

  final EquationsCubit equationsCubit;
  EquationEditorCubit(this.equationsCubit) : super(EquationEditorIdle());

  void startDevelopping(int eqIdx) {
    emit(EquationEditorDevelop(eqIdx, DevelopStep.Select));
  }

  void cancel() {
    emit(EquationEditorIdle());
  }

  void nextStep() {
    var inState = state;
    if (inState is EquationEditorEditing) {
      emit(inState.nextStep(equationsCubit));
    }
  }

  void onSelect(Value value) {
    var inState = state;
    if (inState is EquationEditorEditing) {
      emit(inState.onSelect(value));
    }
  }

}
