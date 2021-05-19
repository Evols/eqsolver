
import 'package:formula_transformator/core/values/utils.dart';

abstract class Value implements Comparable {

  const Value();

  List<Value> getChildren();
  Value deepClone();
  Value deepCloneWithChildren(List<Value> newChildren);
  Value getNormalized();
  String toLatex();

  int compareToClass(Value other) {
    return getValueClassId(this).compareTo(getValueClassId(other));
  }

  bool isEquivalentTo(Value other) {
    return getNormalized() == other.getNormalized();
  }

  @override
  bool operator==(Object other) {
    if (!(other is Value)) {
      return true;
    }
    return compareTo(other) == 0;
  }

}
