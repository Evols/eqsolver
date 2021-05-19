
import 'package:flutter/widgets.dart';
import 'package:flutter_math_fork/flutter_math.dart';

Widget latexToWidget(String latex, [double sizeFactor = 1.0]) {
  return Math.tex(
    latex,
    mathStyle: MathStyle.display,
    textScaleFactor: 1.4 * sizeFactor,
  );
}
