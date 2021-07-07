import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/named_constant.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:formula_transformator/core/parser.dart';
import 'package:formula_transformator/cubit/equation_adder_cubit.dart';
import 'package:formula_transformator/cubit/equation_editor_cubit.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/cubit/value_evaluator_cubit.dart';
import 'package:formula_transformator/widgets/appbar.dart';
import 'package:formula_transformator/widgets/equations_list_body.dart';
import 'package:formula_transformator/widgets/equations_textfield_body.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // y*(a*x+b)=c
    // y=p=7789 ; q=2281 ; c=pq=17766709, a=2^7=128 ; b=q%a=2281%128=105 ; x=(q-b)/a=17

    // General formula
    final eqNamed = Equation(
      Multiplication([
        Variable('y'),
        Addition([
          Multiplication([
            NamedConstant('a'),
            Variable('x'),
          ]),
          NamedConstant('b'),
        ]),
      ]),
      NamedConstant('c'),
    );

    // Right one
    final eq1Literal = Equation(
      Multiplication([
        Variable('y'),
        Addition([
          Multiplication([
            LiteralConstant(BigInt.from(128)),
            Variable('x'),
          ]),
          LiteralConstant(BigInt.from(105)),
        ]),
      ]),
      LiteralConstant(BigInt.from(17766709)),
    );

    // Wrong one
    final eq2Literal = Equation(
      Multiplication([
        Variable('y'),
        Addition([
          Multiplication([
            LiteralConstant(BigInt.from(128)),
            Variable('x'),
          ]),
          LiteralConstant(BigInt.from(97)),
        ]),
      ]),
      LiteralConstant(BigInt.from(17766709)),
    );

    // Wrong one
    final eqFactor = Equation(
      Addition([
        Multiplication([
          LiteralConstant(BigInt.from(5*7*13)),
          const NamedConstant('a'),
          const Variable('y'),
        ]),
        Multiplication([
          LiteralConstant(BigInt.from(5*7)),
          const NamedConstant('a'),
          const Variable('x'),
        ]),
        Multiplication([
          LiteralConstant(BigInt.from(7*13)),
          const NamedConstant('b'),
          const Variable('x'),
          const Variable('z'),
        ]),
      ]),
      LiteralConstant(BigInt.zero),
    );

    // simplify(v2^2*b^2+a^2*k2^2+c^2*u1^2*u2^2-2*a*b*v2*k2+2*b*c*u1*v2-2*a*c*u1*u2*k2+4*b*c*u2*v1*k2+4*b*c*u1*v2)

    return MultiBlocProvider(
      providers: [
        BlocProvider<EquationsCubit>(create: (context) => EquationsCubit([ eqNamed ])),
        BlocProvider<EquationEditorCubit>(create: (context) => EquationEditorCubit(BlocProvider.of<EquationsCubit>(context))),
        BlocProvider<ValueEvaluatorCubit>(create: (context) => ValueEvaluatorCubit(BlocProvider.of<EquationsCubit>(context))),
        BlocProvider<EquationAdderCubit>(create: (context) => EquationAdderCubit()),
      ],
      child: MaterialApp(
        title: 'Formula transformator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(title: 'Formula transformator'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {

  HomePage({ Key? key, required this.title }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: MainAppbar(titleName: this.title),
    body: Column(
      children: [
        Expanded(
          child: EquationsListBody(),
        ),
        EquationsTextfieldBody(),
      ],
    ),
  );
}
