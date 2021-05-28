
import 'package:formula_transformator/core/values/utils.dart';

abstract class Value implements Comparable {

  const Value();

  List<Value> getChildren();
  Value deepClone();
  Value deepCloneWithChildren(List<Value> newChildren);
  Value getNormalized();
  bool get isConstant;

  int compareToClass(Value other) {
    return getValueClassId(this).compareTo(getValueClassId(other));
  }

  bool isEquivalentTo(Value other) {
    return getNormalized() == other.getNormalized();
  }

  @override
  // ignore: hash_and_equals
  bool operator==(Object other) {
    if (!(other is Value)) {
      return true;
    }
    return compareTo(other) == 0;
  }

  List<Value> whereTree(bool Function(Value) recurser) {
    return [
      ...(recurser(this) ? [ this ] : []),
      ...getChildren().map((e) => e.whereTree(recurser)).expand((e) => e).toList(),
    ];
  }

  Value? findTree(bool Function(Value) recurser) {
    if (recurser(this)) {
      return this;
    }
    return getChildren().fold(null, (value, element) => value ?? element.findTree(recurser));
  }

  Value mountAt(Value at, Value toMount) {
    if (identical(this, at)) {
      return toMount;
    }
    final children = getChildren();
    if (children.isEmpty) {
      return this;
    }
    return deepCloneWithChildren(children.map(
      (e) => e.mountAt(at, toMount)
    ).toList());
  }

}
