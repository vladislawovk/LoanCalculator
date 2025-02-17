import 'package:flutter/material.dart';

import '../utils/calculator_logic.dart';

class PaymentTypeSelector extends StatefulWidget {
  final Function(PaymentType) onChanged;

  const PaymentTypeSelector({super.key, required this.onChanged});

  @override
  PaymentTypeSelectorState createState() => PaymentTypeSelectorState();
}

class PaymentTypeSelectorState extends State<PaymentTypeSelector> {
  PaymentType _paymentType = PaymentType.annuity;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Тип платежа:',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        RadioListTile<PaymentType>(
          title: const Text('Аннуитетный'),
          value: PaymentType.annuity,
          groupValue: _paymentType,
          onChanged: (PaymentType? value) {
            setState(() {
              _paymentType = value!;
            });
            widget.onChanged(_paymentType);
          },
        ),
        RadioListTile<PaymentType>(
          title: const Text('Дифференцированный'),
          value: PaymentType.differentiated,
          groupValue: _paymentType,
          onChanged: (PaymentType? value) {
            setState(() {
              _paymentType = value!;
            });
            widget.onChanged(_paymentType);
          },
        ),
      ],
    );
  }
}
