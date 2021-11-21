
List<T> flipExistenceArray<T>(List<T> list, T elem) {
  final shrunk = list.where((e) => !identical(elem, e)).toList();
  if (shrunk.length != list.length) {
    return shrunk;
  } else {
    return [ ...list, elem ];
  }
}

class Ref<T> {
  T value;
  Ref(this.value);
}

BigInt extEuclidAlgo(BigInt a, BigInt b, Ref<BigInt> u0, Ref<BigInt> v0) {

  final aSign = BigInt.from(a.sign);
  final bSign = BigInt.from(b.sign);

  a = a.abs();
  b = b.abs();

  BigInt q, r, s, t, tmp;

  u0.value = BigInt.from(1);
  v0.value = BigInt.from(0);
  s = BigInt.from(0);
  t = BigInt.from(1);

  while (b > BigInt.from(0)) {
    q = a ~/ b;
    r = a % b;
    a = b;
    b = r;
    tmp = s;
    s = u0.value - q * s;
    u0.value = tmp;
    tmp = t;
    t = v0.value - q * t;
    v0.value = tmp;
  }

  u0.value *= aSign;
  v0.value *= bSign;

  return a;
}
