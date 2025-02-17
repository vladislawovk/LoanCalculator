import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.labelText,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
          ),
          validator: validator),
    );
  }
}