import 'package:flutter/material.dart';
import '../utils/calculator_logic.dart';
import '../widgets/input_field.dart';
import '../widgets/payment_type_selector.dart';
import '../widgets/result_display.dart';

/// Файл для отображения экрана калькулятора и валидации UI (не продакшн реализация)
/// Метод _calculatePayment парсит значения из полей ввода

// Эту валидацию можно вынести в отдельные файлы, либо на реальном проекте с использованием стейт менеджмента это всё можно вынести в слой бизнес логики
String? _validateLoanAmount(String? value) {
  if (value == null || value.isEmpty) {
    return 'Введите сумму кредита';
  }
  if (double.tryParse(value) == null || double.parse(value) <= 0) {
    return 'Сумма кредита должна быть положительным числом';
  }
  return null;
}

String? _validateInterestRate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Введите процентную ставку';
  }
  if (double.tryParse(value) == null || double.parse(value) < 0) {
    return 'Процентная ставка должна быть неотрицательным числом';
  }
  return null;
}

String? _validateLoanTermMonths(String? value) {
  if (value == null || value.isEmpty) {
    return 'Введите срок кредита';
  }
  if (int.tryParse(value) == null || int.parse(value) <= 0) {
    return 'Срок кредита должен быть положительным целым числом';
  }
  return null;
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _loanTermMonthsController =
      TextEditingController();

  PaymentType _paymentType = PaymentType.annuity;
  Map<String, double> _results = {};
  String _errorMessage = '';

  void _calculatePayment() {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _errorMessage = '';
        double loanAmount = double.parse(
            _loanAmountController.text.replaceAll(RegExp(r'[^0-9]'), ''));
        double interestRate = double.parse(_interestRateController.text);
        int loanTermMonths = int.parse(_loanTermMonthsController.text);

        try {
          _results = calculateLoanPayment(
              paymentType: _paymentType,
              loanAmount: loanAmount,
              interestRate: interestRate,
              loanTermMonths: loanTermMonths);
        } catch (e) {
          _errorMessage = 'Ошибка расчёта: ${e.toString()}';
          _results = {};
        }
      });
    } else {
      // Здесь лучше использовать логи, или добавить логику обработки невалидной формы
      print("FormState is null");
    }
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _loanTermMonthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Расчёт кредита'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                InputField(
                  labelText: 'Сумма кредита',
                  controller: _loanAmountController,
                  validator: _validateLoanAmount,
                ),
                InputField(
                  labelText: 'Ставка (%)',
                  controller: _interestRateController,
                  validator: _validateInterestRate,
                ),
                InputField(
                  labelText: 'Срок (месяцы)',
                  controller: _loanTermMonthsController,
                  validator: _validateLoanTermMonths,
                ),
                PaymentTypeSelector(
                  onChanged: (type) {
                    _paymentType = type;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _calculatePayment();
                  },
                  child: Text('Рассчитать'),
                ),
                SizedBox(height: 20),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                if (_results.isNotEmpty) ResultDisplay(results: _results),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
