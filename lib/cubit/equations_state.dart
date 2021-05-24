
part of 'equations_cubit.dart';

@immutable
class EquationsState {
  final bool prettifyEquations;
  final List<Value> equations;
  EquationsState(this.equations, this.prettifyEquations);
}
