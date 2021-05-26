part of 'equation_editor_cubit.dart';

@immutable
abstract class EquationEditorState {}

class EquationEditorIdle extends EquationEditorState {}

enum Selectable {
  None, SingleEmpty, SingleSelected, MultipleEmpty, MultipleSelected,
}

abstract class EquationEditorEditing extends EquationEditorState {

  bool hasFinished();
  String getStepName();
  Selectable isSelectable(Equation equation, Value value);
  bool canValidate();

  EquationEditorState nextStep(EquationsCubit equationsCubit);
  EquationEditorEditing onSelect(Equation equation, Value value);

  EquationEditorEditing();

}
