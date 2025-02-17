import 'dart:math';

/// Файл бизнес-логики, содержит enum PaymentType, который задаёт все возможные типы платежей
/// Так же здесь находятся приватыне функции для рассчёта кредита по типу платежа
/// calculateLoanPayment - публичная функция для доступа к расчётам

enum PaymentType { annuity, differentiated }

const String monthlyPaymentKey = 'monthlyPayment';
const String totalPaymentKey = 'totalPayment';
const String overpaymentKey = 'overpayment';
const String loanAmountKey = 'loanAmount';

// Константы для использования в формулах расчётов
const double _percentageDivider = 100.0;
const int _monthsInYear = 12;
const double _zeroInterestRate = 0.0;
const int _one = 1;

Map<String, double> _calculateAnnuityPayment({
  required double loanAmount,
  required double interestRate,
  required int loanTermMonths,
}) {
  int loanTermInMonths = loanTermMonths;
  double monthlyInterestRate =
      interestRate / _percentageDivider / _monthsInYear;
  double monthlyPayment;

  if (monthlyInterestRate == _zeroInterestRate) {
    monthlyPayment = loanAmount / loanTermInMonths;
  } else {
    monthlyPayment = loanAmount *
        (monthlyInterestRate *
            pow((_one + monthlyInterestRate), loanTermInMonths)) /
        (pow((_one + monthlyInterestRate), loanTermInMonths) - _one);
  }

  double totalPayment = monthlyPayment * loanTermInMonths;
  double overpayment = totalPayment - loanAmount;

  return {
    monthlyPaymentKey: monthlyPayment,
    totalPaymentKey: totalPayment,
    overpaymentKey: overpayment,
    loanAmountKey: loanAmount,
  };
}

Map<String, double> _calculateDifferentiatedPayment({
  required double loanAmount,
  required int loanTermMonths,
  required double interestRate,
}) {
  double monthlyInterestRate =
      interestRate / _percentageDivider / _monthsInYear;
  double principalPayment = loanAmount / loanTermMonths;
  double totalPayment = 0;
  double overpayment = 0;
  double remainingLoanAmount = loanAmount;
  double monthlyPayment = 0;

  for (int currentMonthNumber = _one;
      currentMonthNumber <= loanTermMonths;
      currentMonthNumber++) {
    double interestPayment = remainingLoanAmount * monthlyInterestRate;
    monthlyPayment = principalPayment + interestPayment;
    totalPayment += monthlyPayment;
    remainingLoanAmount -= principalPayment;
  }
  overpayment = totalPayment - loanAmount;

  return {
    monthlyPaymentKey: monthlyPayment,
    totalPaymentKey: totalPayment,
    overpaymentKey: overpayment,
    loanAmountKey: loanAmount,
  };
}

Map<String, double> calculateLoanPayment({
  required PaymentType paymentType,
  required double loanAmount,
  required double interestRate,
  required int loanTermMonths,
}) {
  switch (paymentType) {
    case PaymentType.annuity:
      return _calculateAnnuityPayment(
          loanAmount: loanAmount,
          interestRate: interestRate,
          loanTermMonths: loanTermMonths);
    case PaymentType.differentiated:
      return _calculateDifferentiatedPayment(
          loanAmount: loanAmount,
          loanTermMonths: loanTermMonths,
          interestRate: interestRate);
    default:
      // На всякий случай, вдруг придумают новый тип платежа
      throw ArgumentError('Неизвестный тип платежа: $paymentType');
  }
}