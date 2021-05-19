import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/variable.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';

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

    final eq = Addition([
      Multiplication([
        Constant(2),
        Variable("x"),
      ]),
      Constant(1),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<EquationsCubit>(create: (context) => EquationsCubit([ eq ])),
        ],
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<EquationsCubit, EquationsState>(
                builder: (context, state) => ListView.builder(
                  itemCount: state.equations.length,
                  itemBuilder: (context, index) => Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          state.equations[index].toLatex(),
                          Math.tex(
                            r'=0',
                            mathStyle: MathStyle.display,
                            textScaleFactor: 1.4,
                          ),
                        ],
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
