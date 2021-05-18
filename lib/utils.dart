
int compareLists<E extends Comparable>(List<E> first, List<E> second) {
  if (first.length != second.length) {
    return first.length.compareTo(second.length);
  }
  for (var i = 0; i < first.length; i++) {
    final comp = first[i].compareTo(second[i]);
    if (comp != 0) {
      return comp;
    }
  }
  return 0;  
}
