import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';

class Calculator extends StatefulWidget {
  final Function inputFunction;

  const Calculator({required this.inputFunction, Key? key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  late Function _inputFunction;
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _inputFunction = widget.inputFunction;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleCalculator(
      value: _currentValue,
      hideExpression: false,
      hideSurroundingBorder: true,
      onChanged: (key, value, expression) {
        setState(() {
          _currentValue = value ?? 0;
          _inputFunction(_currentValue);
        });
      },
      theme: const CalculatorThemeData(
        borderColor: Colors.black,
        borderWidth: 2,
        displayColor: Color(0xFFD5AC4E),
        displayStyle: TextStyle(fontSize: 80, color: Colors.black),
        expressionColor: Color(0xFFD5AC4E),
        expressionStyle: TextStyle(fontSize: 20, color: Colors.white),
        operatorColor: Color(0xFF45050C),
        operatorStyle: TextStyle(fontSize: 30, color: Colors.white),
        commandColor: Color(0xFF8B6220),
        commandStyle: TextStyle(fontSize: 30, color: Colors.white),
        numColor: Color(0xFF720E07),
        numStyle: TextStyle(fontSize: 50, color: Colors.white),
      ),
    );
  }
}
