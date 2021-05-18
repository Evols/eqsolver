
import 'package:formula_transformator/values/utils.dart';

abstract class Value implements Comparable {

  List<Value> getChildren();
  Value deepClone();
  Value getNormalized();

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

  const Value();

}
