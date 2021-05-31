
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formula_transformator/core/equation.dart';
import 'package:formula_transformator/core/expressions/addition.dart';
import 'package:formula_transformator/core/expressions/expression.dart';
import 'package:formula_transformator/core/expressions/literal_constant.dart';
import 'package:formula_transformator/core/expressions/multiplication.dart';
import 'package:formula_transformator/core/expressions/variable.dart';
import 'package:formula_transformator/core/trivializers/trivializers_applier.dart';
import 'package:formula_transformator/cubit/equations_cubit.dart';
import 'package:formula_transformator/cubit/value_evaluator_cubit.dart';
import 'package:formula_transformator/extensions.dart';
import 'package:formula_transformator/widgets/equation_widget.dart';

class ValueEvalEditor extends StatelessWidget {

  const ValueEvalEditor({Key? key}) : super(key: key);

  static Set<String> getVars(List<Expression> expressions) => expressions.flatMap(
    (part) => part.foldTree<Set<String>>(
      {},
      (accumulator, expression) => expression is Variable ? { ...accumulator, expression.name } : accumulator
    )
  ).toSet();

  static int getVarsCount(List<Expression> expressions) => getVars(expressions).length;

  static Map<String, BigInt> trySolveEquation(Equation equation) {

    if (getVarsCount(equation.parts) != 1) {
      return <String, BigInt>{};
    }

    final asSinglePart = applyTrivializers(Addition([
      equation.rightPart,
      Multiplication([
        LiteralConstant(BigInt.from(-1)),
        equation.leftPart,
      ]),
    ]));

    var constantTermSum = BigInt.zero;
    Expression? nonConstantTerm;
    if (asSinglePart is Addition) {
      for (var term in asSinglePart.terms) {
        if (term is LiteralConstant) {
          constantTermSum += term.number;
        } else if ((term is Multiplication || term is Variable) && nonConstantTerm == null) {
          nonConstantTerm = term;
        } else {
          return <String, BigInt>{};
        }
      }
    } else if (asSinglePart is Multiplication || asSinglePart is Variable) {
      nonConstantTerm = asSinglePart;
    }

    if (nonConstantTerm == null) {
      return <String, BigInt>{};
    }

    var constantFactorProduct = BigInt.one;
    Variable? nonConstantFactor;
    if (nonConstantTerm is Multiplication) {
      for (var factor in nonConstantTerm.factors) {
        if (factor is LiteralConstant) {
          constantFactorProduct *= factor.number;
        } else if ((factor is Variable) && nonConstantFactor == null) {
          nonConstantFactor = factor;
        } else {
          return <String, BigInt>{};
        }
      }
    }

    if (nonConstantFactor == null) {
      return <String, BigInt>{};
    }

    if (constantTermSum % constantFactorProduct != BigInt.zero) {
      return <String, BigInt>{};
    }

    return <String, BigInt>{ nonConstantFactor.name: (-constantTermSum ~/ constantFactorProduct) };
  }

  static List<Equation> injectVarValues(List<Equation> equations, Map<String, BigInt> values) => equations.map(
    (equation) => Equation.fromParts(equation.parts.map(
      (part) => applyTrivializers(part.mountWithGenerator(
        (expression) => (
          (expression is Variable && values.containsKey(expression.name)) 
          ? LiteralConstant(values[expression.name]!)
          : null
        )
      ))
    ).toList())
  ).toList();

  @override
  Widget build(BuildContext context) => BlocBuilder<EquationsCubit, EquationsState>(
    builder: (context, equationsState) => BlocProvider<ValueEvaluatorCubit>(
      create: (_) => ValueEvaluatorCubit(BlocProvider.of<EquationsCubit>(context)),
      child: BlocBuilder<ValueEvaluatorCubit, ValueEvaluatorState>(
        builder: (context, editorState) {

          var solutions = <String, BigInt>{ ...editorState.values };
          var solvedEquations = injectVarValues(equationsState.equations, solutions);
          var justChanged = true;
          while (justChanged) {
            final newSolutions = solvedEquations.flatMap(
              (equation) => trySolveEquation(equation).entries
            ).toList();
            justChanged = newSolutions.isNotEmpty;
            solutions.addAll(Map.fromEntries(newSolutions));
            solvedEquations = injectVarValues(solvedEquations, solutions);
          }

          final varIds = getVars(equationsState.equations.flatMap(
            (equation) => equation.parts
          ).toList());

          // print('solvedEquations: $solvedEquations');
          print('solutions: $solutions');
          print('vars: $varIds');

          return AlertDialog(
            title: const Text('Value evaluator'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ...varIds.map(
                  (varId) => (
                    solutions.containsKey(varId)
                    ? LatexWidget(varId + '=' + solutions[varId].toString())
                    : Row(children: [
                      Spacer(),
                      LatexWidget(varId + '='),
                      Container(width: 8),
                      Container(
                        height: 40,
                        width: 100,
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: const OutlineInputBorder(gapPadding: 1),
                            labelText: 'Valeur',
                          ),
                          onSubmitted: (value) => BlocProvider.of<ValueEvaluatorCubit>(context).setValue(varId, BigInt.parse(value)),
                        ),
                      ),
                      Spacer(),
                    ])
                  )
                )
                // const Text('Evaluate values'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        }
      ),
    ),
  );
}