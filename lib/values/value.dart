
import 'package:formula_transformator/values/utils.dart';

abstract class Value implements Comparable {

  List<Value> getChildren();
  Value deepClone();

  int compareToClass(Value other) {
    return getValueClassId(other) - getValueClassId(this);
  }

  const Value();
}
