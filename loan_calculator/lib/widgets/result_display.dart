import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_calculator/widgets/payment_chart.dart';
import '../utils/calculator_logic.dart';

/// В этом файле находятся виджеты для отображения результатов расчётов по кредиту
/// Так же здесь вызывается виджет для отображения диаграммы
/// ResultDisplay получает данные из мапы results, которая приходит из calculator_logic.dart, форматирует данные под локаль RU
/// _buildResultRow создаёт строку в виде label - Value

class ResultDisplay extends StatelessWidget {
  final Map<String, double> results;

  const ResultDisplay({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'ru_RU', symbol: '₽');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Расчёт:',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildResultRow('Ежемесячный платеж:',
            currencyFormat.format(results[monthlyPaymentKey] ?? 0)),
        _buildResultRow('Сумма выплат:',
            currencyFormat.format(results[totalPaymentKey] ?? 0)),
        _buildResultRow(
            'Переплата:', currencyFormat.format(results[overpaymentKey] ?? 0)),
        SizedBox(height: 20),
        PaymentChart(
            overpayment: results[overpaymentKey] ?? 0,
            loanAmount: results[loanAmountKey] ?? 0),
      ],
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label),
          Text(value),
        ],
      ),
    );
  }
}