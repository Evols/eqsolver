
import 'package:formula_transformator/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/values/addition.dart';
import 'package:formula_transformator/values/constant.dart';
import 'package:formula_transformator/values/multiplication.dart';

void main(List<String> arguments) {
  const a = Addition([
    Constant(1.0),
    Multiplication([
      Constant(50.0),
      Constant(2.0),
    ]),
  ]);
  print(apply_trivializers(a));
}
