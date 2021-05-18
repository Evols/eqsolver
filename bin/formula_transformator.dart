
import 'package:formula_transformator/values/addition.dart';
import 'package:formula_transformator/values/constant.dart';

void main(List<String> arguments) {
  const a = Addition([
    Constant(50),
    Constant(60),
  ]);
  const b = Addition([
    Constant(60),
    Constant(50),
  ]);
  print(a == b);
  print(a.isEquivalentTo(b));
}
