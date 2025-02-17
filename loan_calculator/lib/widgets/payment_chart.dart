import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Этот файл содержит два виджета:
/// PaymentChart для отображения круглой диаграммы, визуализирующей результаты расчёта кредита
/// _LegendItem для отображения элементов легенды диаграммы */

// Константы для размеров
const double _loanSectionRadiusRatio = 0.8;
const double _overpaymentSectionRadiusRatio = 0.82;
const double _legendLeftPadding = 60.0;
const double _legendItemSpacing = 10.0;
const double _legendColorBoxSize = 12.0;
const double _legendColorBoxTextSpacing = 4.0;
const String _pieChartSectionDefaultTitle = '';

class PaymentChart extends StatelessWidget {
  final double overpayment;
  final double loanAmount;
  final Color loanColor;
  final Color overpaymentColor;
  final String loanLabel;
  final String overpaymentLabel;

  const PaymentChart({
    super.key,
    required this.overpayment,
    required this.loanAmount,
    this.loanColor = Colors.blueGrey,
    this.overpaymentColor = Colors.lightBlue,
    this.loanLabel = 'Сумма',
    this.overpaymentLabel = 'Переплата',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double chartRadius = constraints.maxWidth / 2;
                double loanSectionRadius =
                    chartRadius * _loanSectionRadiusRatio;
                double overpaymentSectionRadius =
                    chartRadius * _overpaymentSectionRadiusRatio;

                return AspectRatio(
                  aspectRatio: 1.1,
                  child: PieChart(
                    PieChartData(
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 2,
                      centerSpaceRadius: 0,
                      sections: _generateChartSections(
                          loanSectionRadius, overpaymentSectionRadius),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: _legendLeftPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LegendItem(color: loanColor, text: loanLabel),
                SizedBox(height: _legendItemSpacing),
                _LegendItem(color: overpaymentColor, text: overpaymentLabel),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _generateChartSections(
      double loanSectionRadius, double overpaymentSectionRadius) {
    return [
      PieChartSectionData(
        color: loanColor,
        value: loanAmount,
        title: _pieChartSectionDefaultTitle,
        radius: loanSectionRadius,
      ),
      PieChartSectionData(
        color: overpaymentColor,
        value: overpayment,
        title: _pieChartSectionDefaultTitle,
        radius: overpaymentSectionRadius,
      ),
    ];
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: _legendColorBoxSize,
          height: _legendColorBoxSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: _legendColorBoxTextSpacing),
        Text(text),
      ],
    );
  }
}
