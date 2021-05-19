
extension ExtendedIterable<E> on Iterable<E> {
  T foldIndexed<T>(T initialValue, T combine(T previousValue, E element, int index)) {
    var value = initialValue;
    int i = 0;
    for (E element in this) value = combine(value, element, i++);
    return value;
  }
}
