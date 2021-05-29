
import 'package:bloc/bloc.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/values/value.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/cubit/editors/equation_editor_develop.dart';
import 'package:formula_transformator/cubit/editors/equation_editor_dioph.dart';
import 'package:formula_transformator/cubit/editors/equation_editor_factorize.dart';
import 'package:formula_transformator/cubit/editors/equation_editor_inject.dart';
import 'package:formula_transformator/cubit/editors/equation_editor_reorganize.dart';
import 'package:meta/meta.dart';

part 'equation_editor_state.dart';

class EquationEditorCubit extends Cubit<EquationEditorState> {

  final EquationsCubit equationsCubit;
  EquationEditorCubit(this.equationsCubit) : super(EquationEditorIdle());

  void startDevelopping(int eqIdx) {
    emit(EquationEditorDevelop(eqIdx, DevelopStep.Select));
  }

  void startFactoring(int eqIdx) {
    emit(EquationEditorFactorize(eqIdx, FactorizeStep.SelectFactor));
  }

  void startDioph(int eqIdx) {
    emit(EquationEditorDioph(eqIdx, DiophStep.SelectTerms));
  }

  void startInject(int eqIdx) {
    emit(EquationEditorInject(eqIdx, InjectStep.SelectSubstitute));
  }

  void startReorganize(int eqIdx) {
    emit(EquationEditorReorganize(eqIdx, ReorganizeStep.Select));
  }

  void cancel() {
    emit(EquationEditorIdle());
  }

  void computeValueOfEqs() {
    emit(EquationEditorIdle());
  }

  void nextStep() {
    var inState = state;
    if (inState is EquationEditorEditing) {
      emit(inState.nextStep(equationsCubit));
    }
  }

  void onSelect(Equation equation, Value value) {
    var inState = state;
    if (inState is EquationEditorEditing) {
      emit(inState.onSelect(equation, value));
    }
  }

}
