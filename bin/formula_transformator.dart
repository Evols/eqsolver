
import 'package:formula_transformator/transformators/add_zero_trivializer.dart';
import 'package:formula_transformator/transformators/mult_one_trivializer.dart';
import 'package:formula_transformator/transformators/mult_zero_trivializer.dart';
import 'package:formula_transformator/values/addition.dart';
import 'package:formula_transformator/values/constant.dart';
import 'package:formula_transformator/values/multiplication.dart';

void main(List<String> arguments) {
  const a = Multiplication([
    Constant(50),
    Constant(1),
  ]);
  print(MultOneTrivializer().transform(a));
}
