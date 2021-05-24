
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

int computeGcd(int a, int b) {
  int t = b;
  while (b != 0) {
    t = b;
    b = a % b;
    a = t;
  }
  return a;
}

int extEuclidAlgo(int a, int b, Ref<int> u0, Ref<int> v0) {

  int q, r, s, t, tmp;

  u0.value = 1;
  v0.value = 0;
  s = 0;
  t = 1;

  while (b > 0) {
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

  return a;
}
