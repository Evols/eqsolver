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
  Selectable isSelectable(Value value);

  EquationEditorEditing nextStep();
  EquationEditorEditing onSelect(Value value);

  EquationEditorEditing();

}

enum DevelopStep { SelectMult, SelectTerms, Finished }

class EquationEditorDevelop extends EquationEditorEditing {

  final int eqIdx;
  final DevelopStep step;
  final Multiplication? selectedMultiplication;
  final List<Addition> selectedAdditions;

  EquationEditorDevelop(this.eqIdx, this.step, { this.selectedMultiplication, List<Addition>? selectedAdditions })
    : this.selectedAdditions = selectedAdditions ?? [];

  @override
  String getStepName() {
    switch (step) {
      case DevelopStep.SelectMult: return "Select the multiplication to develop";
      case DevelopStep.SelectTerms: return "Select the terms to develop";
      default: return "";
    }
  }

  @override
  bool hasFinished() => step == DevelopStep.Finished;

  @override
  Selectable isSelectable(Value value) {
    switch (step) {
    case DevelopStep.SelectMult:
      return (
        value is Multiplication
        ? (
          identical(value, selectedMultiplication)
          ? Selectable.SingleSelected
          : Selectable.SingleEmpty
        )
        : Selectable.None
      );
    case DevelopStep.SelectTerms:
      return (
        value is Addition && selectedMultiplication!.children.where((child) => identical(value, child)).isNotEmpty
        ? (
          selectedAdditions.where((child) => identical(value, child)).isNotEmpty
          ? Selectable.MultipleSelected
          : Selectable.MultipleEmpty
        )
        : Selectable.None
      );
    default:
      return Selectable.None;
    }
  }

  @override
  EquationEditorEditing nextStep() => EquationEditorDevelop(
    eqIdx,
    DevelopStep.values[step.index + 1],
    selectedMultiplication: selectedMultiplication,
    selectedAdditions: selectedAdditions,
  );

  @override
  EquationEditorEditing onSelect(Value value) {
    switch (step) {
    case DevelopStep.SelectMult:
      return EquationEditorDevelop(
        eqIdx,
        step,
        selectedMultiplication: (identical(value, selectedMultiplication) ? null : value as Multiplication),
        selectedAdditions: selectedAdditions,
      );
    case DevelopStep.SelectTerms:
      return EquationEditorDevelop(
        eqIdx,
        step,
        selectedMultiplication: selectedMultiplication,
        selectedAdditions: flipExistenceArray<Addition>(selectedAdditions, value as Addition),
      );
    default:
      return this;
    }
  }

}
