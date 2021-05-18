
abstract class Value {
  List<Value> getChildren();
  Value deepClone();

  const Value();
}
