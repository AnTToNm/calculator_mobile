import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _answer = '';

  void _handleClick(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _expression = '';
        _answer = '';
      } else if (buttonText == '=') {
        _answer = _evaluateExpression(_expression);
      } else if (buttonText == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (buttonText == '√') {
        _expression += '√(';
      } else if (buttonText == 'log') { // Обработка логарифма
        _expression += 'log(';
      } else {
        _expression += buttonText;
      }
    });
  }

  String _evaluateExpression(String expression) {
    List<String> tokens = _tokenize(expression);
    List<String> postfix = _infixToPostfix(tokens);
    return _evaluatePostfix(postfix);
  }

  List<String> _tokenize(String expression) {
    List<String> tokens = [];
    String buffer = '';
    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];
      if (char == '+' || char == '-' || char == '×' || char == '÷' || char == '(' || char == ')' || char == '√' || char == 'log') {
        if (buffer.isNotEmpty) {
          tokens.add(buffer);
          buffer = '';
        }
        tokens.add(char);
      } else {
        buffer += char;
      }
    }
    if (buffer.isNotEmpty) {
      tokens.add(buffer);
    }
    return tokens;
  }

  int _precedence(String op) {
    if (op == '+' || op == '-') {
      return 1;
    } else if (op == '×' || op == '÷' || op == '√' || op == 'log') {
      return 2;
    }
    return 0;
  }

  List<String> _infixToPostfix(List<String> tokens) {
    List<String> postfix = [];
    List<String> stack = [];

    for (int i = 0; i < tokens.length; i++) {
      String token = tokens[i];

      if (token == '(') {
        stack.add(token);
      } else if (token == ')') {
        while (stack.isNotEmpty && stack.last != '(') {
          postfix.add(stack.removeLast());
        }
        stack.removeLast(); // Remove '('
      } else if (token == '+' || token == '-' || token == '×' || token == '÷' || token == '√' || token == 'log') {
        while (stack.isNotEmpty && _precedence(stack.last) >= _precedence(token)) {
          postfix.add(stack.removeLast());
        }
        stack.add(token);
      } else {
        postfix.add(token);
      }
    }

    while (stack.isNotEmpty) {
      postfix.add(stack.removeLast());
    }

    return postfix;
  }

  String _evaluatePostfix(List<String> postfix) {
    List<double> stack = [];

    for (int i = 0; i < postfix.length; i++) {
      String token = postfix[i];

      if (token == '+' || token == '-' || token == '×' || token == '÷' || token == '√' || token == 'log') {
        if (token == '√') {
          double operand = stack.removeLast();
          double result = sqrt(operand);
          stack.add(result);
        } else if (token == 'log') { // Обработка логарифма
          double base = stack.removeLast();
          double operand = stack.removeLast();
          double result = log(base) / log(operand);
          stack.add(result);
        } else {
          double num2 = stack.removeLast();
          double num1 = stack.removeLast();
          double result = _calculate(num1, num2, token);
          stack.add(result);
        }
      } else {
        stack.add(double.parse(token));
      }
    }

    return stack.isNotEmpty ? stack[0].toString() : '';
  }

  double _calculate(double num1, double num2, String operation) {
    switch (operation) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '×':
        return num1 * num2;
      case '÷':
        return num1 / num2;
      default:
        throw Exception('Invalid operation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator',
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                SizedBox(width: 10.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.blue),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        _expression,
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                SizedBox(width: 10.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.blue),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        _answer,
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildButton('√'),
              _buildButton('log')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildButton('C'),
              _buildButton('('),
              _buildButton(')'),
              _buildButton('⌫'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('÷'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('×'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('-'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('0'),
              _buildButton('.'),
              _buildButton('='),
              _buildButton('+'),
            ],
          ),


        ],
      ),
    );
  }

  Widget _buildButton(String buttonText) {
    return Container(
      margin: EdgeInsets.all(4.0), // Отступы для кнопок
      child: MaterialButton(
        padding: EdgeInsets.all(20.0), // Отступы на 1 пиксель меньше для добавления границы
        onPressed: () => _handleClick(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white, // Цвет текста
          ),
        ),
        color: Colors.lightBlue, // Цвет кнопок
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.blue), // Границы кнопок
        ),
      ),
    );
  }
}
