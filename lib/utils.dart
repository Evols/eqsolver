
List<T> flipExistenceArray<T>(List<T> list, T elem) {
  final shrunk = list.where((e) => !identical(elem, e)).toList();
  if (shrunk.length != list.length) {
    return shrunk;
  } else {
    return [ ...list, elem ];
  }
}
