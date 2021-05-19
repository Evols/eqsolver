import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:formula_transformator/core/values/addition.dart';
import 'package:formula_transformator/core/values/constant.dart';
import 'package:formula_transformator/core/values/multiplication.dart';
import 'package:formula_transformator/core/values/variable.dart';

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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Column(
        // mainAxisAlignment: ,
        children: [
          Expanded(
            child: Math.tex(eq.toLatex(), mathStyle: MathStyle.display, textScaleFactor: 1.4)
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
}
