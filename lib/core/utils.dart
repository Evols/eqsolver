
import 'package:formula_transformator/core/values/value.dart';

int compareLists<E extends Comparable>(List<E> first, List<E> second) {
  if (first.length != second.length) {
    return first.length.compareTo(second.length);
  }
  for (var i = 0; i < first.length; i++) {
    final comp = first[i].compareTo(second[i]);
    if (comp != 0) {
      return comp;
    }
  }
  return 0;
}

Value? mountValueAt(Value baseValue, Value? Function(Value, int) replacer, [int depth = 0]) {

  final replacerResult = replacer(baseValue, depth);
  if (replacerResult != null) {
    return replacerResult;
  }

  final children = baseValue.getChildren();
  for (var foundIdx = 0; foundIdx < children.length; foundIdx++) {
    final child = children[foundIdx];
    final mounted = mountValueAt(child, replacer, depth + 1);
    if (mounted != null) {
      final dcwc = baseValue.deepCloneWithChildren([ ...children.sublist(0, foundIdx), mounted, ...children.sublist(foundIdx + 1) ]);
      return dcwc;
    }
  }

  return null;
}
