import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/named_constant.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:formula_transformator/cubit/equation_editor_cubit.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/widgets/button.dart';
import 'package:formula_transformator/widgets/equation_widget.dart';
import 'package:formula_transformator/widgets/value_eval_editor.dart';

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

    // simplify(v2^2*b^2+a^2*k2^2+c^2*u1^2*u2^2-2*a*b*v2*k2+2*b*c*u1*v2-2*a*c*u1*u2*k2+4*b*c*u2*v1*k2+4*b*c*u1*v2)

    return MultiBlocProvider(
      providers: [
        BlocProvider<EquationsCubit>(create: (context) => EquationsCubit([ eqNamed ])),
        BlocProvider<EquationEditorCubit>(create: (context) => EquationEditorCubit(BlocProvider.of<EquationsCubit>(context))),
      ],
      child: MaterialApp(
        title: 'Formula transformator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Formula transformator'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {

  MyHomePage({ Key? key, required this.title }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: BlocBuilder<EquationsCubit, EquationsState>(
        builder: (context, state) => BlocBuilder<EquationEditorCubit, EquationEditorState>(
          builder: (context, editorState) => Row(
            children: [
              Text(title + (editorState is EquationEditorEditing ? ' - ' + editorState.getStepName() : '')),
              ...(
                editorState is EquationEditorIdle
                ? [
                  Container(width: 8),
                  Button(
                    'Compute the values of variables',
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => ValueEvalEditor(),
                    ),
                  ),
                ]
                : []
              ),
              Spacer(),
              BlocBuilder<EquationEditorCubit, EquationEditorState>(
                builder: (context, editorState) {
                  return Row(
                    children: [
                      ...(editorState is EquationEditorEditing ? [
                        Button(
                          'Cancel',
                          onPressed: () => BlocProvider.of<EquationEditorCubit>(context).cancel(),
                        ),
                        Text(' '),
                        Button(
                          'Validate',
                          onPressed: !editorState.canValidate() ? null : () => BlocProvider.of<EquationEditorCubit>(context).nextStep(),
                        ),
                      ] : []),
                    ],
                  );
                }
              )
            ]
          ),
        ),
      ),
    ),
    body: Column(
      children: [
        Expanded(
          child: BlocBuilder<EquationsCubit, EquationsState>(
            builder: (context, state) => BlocBuilder<EquationEditorCubit, EquationEditorState>(
              builder: (context, editorState) => ListView.builder(
                itemCount: state.equations.length,
                itemBuilder: (context, index) => Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        EquationWidget(
                          state.equations[index],
                          bottomWidgetBuilder: (expression) {
                            if (editorState is EquationEditorEditing) {
                              final selectable = editorState.isSelectable(state.equations[index], expression);
                              switch (selectable) {
                              case Selectable.SingleEmpty:
                              case Selectable.SingleSelected:
                                return Radio<bool>(
                                  splashRadius: 0.0,
                                  value: selectable == Selectable.SingleSelected,
                                  groupValue: true,
                                  onChanged: (_) => BlocProvider.of<EquationEditorCubit>(context).onSelect(state.equations[index], expression),
                                );
                              case Selectable.MultipleEmpty:
                              case Selectable.MultipleSelected:
                                return Checkbox(
                                  splashRadius: 0.0,
                                  value: selectable == Selectable.MultipleSelected,
                                  onChanged: (_) => BlocProvider.of<EquationEditorCubit>(context).onSelect(state.equations[index], expression),
                                );
                                case Selectable.None:
                                  return null;
                              }
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Math.tex(
                              '(${index+1})',
                              mathStyle: MathStyle.display,
                              textScaleFactor: 1.2,
                            ),
                            DropdownButton<void Function()>(
                              selectedItemBuilder: (context) => [ Container( width: 50,) ],
                              iconSize: 24,
                              elevation: 16,
                              isDense: true,
                              underline: Container(),
                              onChanged: (void Function()? newValue) => newValue?.call(),
                              items: editorState is EquationEditorEditing ? [] : [
                                DropdownMenuItem<void Function()>(
                                  value: () => BlocProvider.of<EquationEditorCubit>(context).startDevelopping(),
                                  child: Container(child: Text('Develop', style: TextStyle(fontSize: 14))),
                                ),
                                DropdownMenuItem<void Function()>(
                                  value: () => BlocProvider.of<EquationEditorCubit>(context).startFactoring(),
                                  child: Container(child: Text('Factor', style: TextStyle(fontSize: 14))),
                                ),
                                DropdownMenuItem<void Function()>(
                                  value: () => BlocProvider.of<EquationEditorCubit>(context).startDioph(),
                                  child: Container(child: Text('Diophantine', style: TextStyle(fontSize: 14))),
                                ),
                                DropdownMenuItem<void Function()>(
                                  value: () => BlocProvider.of<EquationEditorCubit>(context).startInject(),
                                  child: Container(child: Text('Inject', style: TextStyle(fontSize: 14))),
                                ),
                                DropdownMenuItem<void Function()>(
                                  value: () => BlocProvider.of<EquationEditorCubit>(context).startReorganize(),
                                  child: Container(child: Text('Reorganize', style: TextStyle(fontSize: 14))),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.black12,
          padding: EdgeInsets.all(8.0),
          child: TextField(),
        ),
      ],
    ),
  );
}
