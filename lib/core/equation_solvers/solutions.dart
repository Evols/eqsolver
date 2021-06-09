
import 'package:flutter/foundation.dart';
import 'package:formula_transformator/extensions.dart';

@immutable
class Solutions {
  final Map<String, BigInt> constants;
  final Map<String, BigInt> variables;

  Solutions copy() => Solutions({ ...constants }, { ...variables });

  Solutions.fromArray(List<Solutions> array):
    constants = Map<String, BigInt>.fromEntries(array.flatMap((solution) => solution.constants.entries)),
    variables = Map<String, BigInt>.fromEntries(array.flatMap((solution) => solution.variables.entries));

  const Solutions([this.constants = const {}, this.variables = const {}]);

  String toString() {
    return 'Solutions( constants: $constants, variables: $variables )';
  }

}
