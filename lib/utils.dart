
List<T> flipExistenceArray<T>(List<T> list, T elem) {
  final shrunk = list.where((e) => !identical(elem, e)).toList();
  if (shrunk.length != list.length) {
    return shrunk;
  } else {
    return [ ...list, elem ];
  }
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