import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}


class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}


class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _input = "";


  void _buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        _input = "";
        _output = "0";
      } else if (value == "←") {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (value == "=") {
        _output = _evaluateExpression(_input);
      } else {
        _input += value;
      }
    });
  }


  String _evaluateExpression(String expression) {
    try {
      // Substituir operadores para formato correto
      expression = expression.replaceAll('x', '*').replaceAll('÷', '/');


      Parser parser = Parser();
      Expression exp = parser.parse(expression);


      ContextModel contextModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, contextModel);


      // Remove ".0" de números inteiros
      return eval.toString().endsWith(".0")
          ? eval.toInt().toString()
          : eval.toString();
    } catch (e) {
      return "Erro";
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        title: Text('Minha calculadora'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Tela de exibição da calculadora
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.teal.shade50,
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _input,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _output,
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Botões da calculadora
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 5 : 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _buttons.length,
                itemBuilder: (context, index) {
                  final button = _buttons[index];
                  return ElevatedButton(
                    onPressed: () => _buttonPressed(button),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isOperator(button)
                          ? Colors.teal
                          : Colors.teal.shade100,
                      foregroundColor: _isOperator(button)
                          ? Colors.white
                          : Colors.teal.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      button,
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  // Lista de botões
  final List<String> _buttons = [
    "C", "÷", "x", "←",
    "7", "8", "9", "-",
    "4", "5", "6", "+",
    "1", "2", "3", "=",
    "0", ".", "%"
  ];


  // Verifica se o botão é operador
  bool _isOperator(String value) {
    return ["÷", "x", "-", "+", "=", "%", "←"].contains(value);
  }
}
