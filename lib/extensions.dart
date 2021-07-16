
extension ExtendedIterable<E> on Iterable<E> {
  T foldIndexed<T>(T initialValue, T combine(T previousValue, E element, int index)) {
    var value = initialValue;
    int i = 0;
    for (E element in this) value = combine(value, element, i++);
    return value;
  }

  Iterable<T> mapIndexed<T>(T f(E e, int i)) {
    int i = 0;
    return map((e) => f(e, i++));
  }

  Iterable<T> flatMap<T>(Iterable<T> f(E e)) => fold<Iterable<T>>([], (acc, e) => [ ...acc, ...f(e) ]);

  Iterable<E> whereIndexed(bool f(E e, int i)) {
    int i = 0;
    return where((e) => f(e, i++));
  }
}

extension ExtendedMap<K, V> on Map<K, V> {
  Map<K, V> where(bool test(K key, V value)) => Map.fromEntries(this.entries.where((element) => test(element.key, element.value)));
}
