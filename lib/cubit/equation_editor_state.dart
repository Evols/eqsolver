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
  Selectable isSelectable(Value root, Value value);
  bool canValidate();

  EquationEditorState nextStep(EquationsCubit equationsCubit);
  EquationEditorEditing onSelect(Value value);

  EquationEditorEditing();

}

enum DevelopStep { Select, Finished }

class EquationEditorDevelop extends EquationEditorEditing {

  final int eqIdx;
  final DevelopStep step;
  final List<Value> selectedTerms;

  EquationEditorDevelop(this.eqIdx, this.step, { List<Value>? selectedTerms })
    : this.selectedTerms = selectedTerms ?? [];

  @override
  String getStepName() {
    switch (step) {
      case DevelopStep.Select: return 'Select the terms to develop';
      default: return '';
    }
  }

  @override
  bool hasFinished() => step == DevelopStep.Finished;

  @override
  Selectable isSelectable(Value root, Value value) {
    switch (step) {
    case DevelopStep.Select:
      if (
        root.findTree(
          (treeIt) => treeIt is Multiplication && treeIt.children.where(
            (factor) => factor is Addition && factor.children.where(
              (term) => identical(term, value)
            ).isNotEmpty && factor.children.where(
              (term) => selectedTerms.where(
                (term2) => identical(term, term2)
              ).isNotEmpty
            ).length == selectedTerms.length
          ).isNotEmpty
        ) != null
      ) {
        return (
          selectedTerms.where((e) => identical(e, value)).isNotEmpty
          ? Selectable.MultipleSelected
          : Selectable.MultipleEmpty
        );
      }
      return Selectable.None;
    default:
      return Selectable.None;
    }
  }

  @override
  bool canValidate() {
    switch (step) {
    case DevelopStep.Select:
      return selectedTerms.length > 0;
    default:
      return true;
    }
  }

  @override
  EquationEditorState nextStep(EquationsCubit equationsCubit) {
    final newStep = DevelopStep.values[step.index + 1];
    if (newStep == DevelopStep.Finished) {

      for (var equation in equationsCubit.state.equations) {

        final multiplication = equation.findTree(
          (treeIt) => treeIt is Multiplication && treeIt.children.where(
            (factor) => factor is Addition && factor.children.where(
              (term) => selectedTerms.where(
                (term2) => identical(term, term2)
              ).isNotEmpty
            ).length == selectedTerms.length
          ).isNotEmpty
        );

        if (multiplication != null) {
          equationsCubit.addEquations(
            DevelopTransformator(selectedTerms).transform(multiplication).map(
              (transformed) => equation.mountAt(multiplication, transformed)
            ).toList()
          );
        }

      }

      return EquationEditorIdle();
    }
    return EquationEditorDevelop(
      eqIdx,
      newStep,
      selectedTerms: selectedTerms,
    );
  }

  @override
  EquationEditorEditing onSelect(Value value) {
    switch (step) {
    case DevelopStep.Select:
      return EquationEditorDevelop(
        eqIdx,
        step,
        selectedTerms: flipExistenceArray<Value>(selectedTerms, value),
      );
    default:
      return this;
    }
  }

}
