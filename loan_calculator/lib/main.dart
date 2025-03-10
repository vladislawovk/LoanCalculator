import 'package:flutter/material.dart';
import 'package:loan_calculator/screens/calculator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Calculator',
      home: CalculatorScreen(),
    );
  }
}
