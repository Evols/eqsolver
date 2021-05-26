import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/variable.dart';
import 'package:formula_transformator/cubit/equation_editor_cubit.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/widgets/equation_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formula transformator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Formula transformator'),
    );
  }
}

class MyHomePage extends StatelessWidget {

  MyHomePage({ Key? key, required this.title }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {

    // y=p=7789 ; q=2281 ; c=pq=17766709, a=2^7=128 ; b=q%a=2281%128=105

    // Right one
    final eq1 = Equation(
      Multiplication([
        Variable('y'),
        Addition([
          Multiplication([
            Constant(128),
            Variable('x'),
          ]),
          Constant(105),
        ]),
      ]),
      Constant(17766709),
    );

    /*
    // Wrong one
    final eq2 = Addition([
      Multiplication([
        Variable('y'),
        Addition([
          Multiplication([
            Constant(128),
            Variable('x'),
          ]),
          Constant(97),
        ]),
      ]),
      Constant(17766709),
    ]);
    */

    return MultiBlocProvider(
      providers: [
        BlocProvider<EquationsCubit>(create: (context) => EquationsCubit([ eq1, /* eq2 */ ])),
        BlocProvider<EquationEditorCubit>(create: (context) => EquationEditorCubit(BlocProvider.of<EquationsCubit>(context))),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<EquationsCubit, EquationsState>(
            builder: (context, state) => BlocBuilder<EquationEditorCubit, EquationEditorState>(
              builder: (context, editorState) => Row(
                children: [
                  Text(title + (editorState is EquationEditorEditing ? ' - ' + editorState.getStepName() : '')),
                  Spacer(),
                  BlocBuilder<EquationEditorCubit, EquationEditorState>(
                    builder: (context, editorState) {
                      return Row(
                        children: [
                          ...(editorState is EquationEditorEditing ? [
                            ElevatedButton(
                              onPressed: () => BlocProvider.of<EquationEditorCubit>(context).cancel(),
                              child: Text('Cancel'),
                            ),
                            Text(' '),
                            ElevatedButton(
                              onPressed: !editorState.canValidate() ? null : () => BlocProvider.of<EquationEditorCubit>(context).nextStep(),
                              child: Text('Validate'),
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
                              bottomWidgetBuilder: (value) {
                                if (editorState is EquationEditorEditing) {
                                  final selectable = editorState.isSelectable(state.equations[index], value);
                                  switch (selectable) {
                                  case Selectable.SingleEmpty:
                                  case Selectable.SingleSelected:
                                    return Radio<bool>(
                                      splashRadius: 0.0,
                                      value: selectable == Selectable.SingleSelected,
                                      groupValue: true,
                                      onChanged: (_) => BlocProvider.of<EquationEditorCubit>(context).onSelect(state.equations[index], value),
                                    );
                                  case Selectable.MultipleEmpty:
                                  case Selectable.MultipleSelected:
                                    return Checkbox(
                                      splashRadius: 0.0,
                                      value: selectable == Selectable.MultipleSelected,
                                      onChanged: (_) => BlocProvider.of<EquationEditorCubit>(context).onSelect(state.equations[index], value),
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
                                  selectedItemBuilder: (context) => [ Container() ],
                                  iconSize: 24,
                                  elevation: 16,
                                  isDense: true,
                                  underline: Container(),
                                  onChanged: (void Function()? newValue) => newValue?.call(),
                                  items: editorState is EquationEditorEditing ? [] : [
                                    DropdownMenuItem<void Function()>(
                                      value: () => BlocProvider.of<EquationEditorCubit>(context).startDevelopping(index),
                                      child: Container(child: Text('Develop')),
                                    ),
                                    DropdownMenuItem<void Function()>(
                                      value: () => BlocProvider.of<EquationEditorCubit>(context).startFactoring(index),
                                      child: Container(child: Text('Factor')),
                                    ),
                                    DropdownMenuItem<void Function()>(
                                      value: () => BlocProvider.of<EquationEditorCubit>(context).startDioph(index),
                                      child: Container(child: Text('Diophantine')),
                                    ),
                                    DropdownMenuItem<void Function()>(
                                      value: () => BlocProvider.of<EquationEditorCubit>(context).startInject(index),
                                      child: Container(child: Text('Inject')),
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
      ),
    );
  }
}
