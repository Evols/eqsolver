
import 'package:flutter/foundation.dart';

// A value interval for a variable. Inclusive: if this is {lowerBound: 4, upperBound: 8}, it includes values 4, 5, 6, 7, 8.
@immutable
class ValueInterval {

  final BigInt lowerBound;
  final BigInt upperBound;

  const ValueInterval(this.lowerBound, this.upperBound);

}

@immutable
class ValueIntervalUnion {

  final List<ValueInterval> intervals;

  const ValueIntervalUnion(this.intervals);

}
