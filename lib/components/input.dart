import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  Input({
    required this.label,
    this.inputType = TextInputType.text,
    this.obscure = false,
    required this.controller,
    this.center = false,
    this.suggestions = false,
  });
  final String label;
  final TextInputType inputType;
  final bool obscure;
  final bool center;
  final bool suggestions;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: !center ? label : null,
          hintText: center ? label : null,
        ),
        textAlign: center ? TextAlign.center : TextAlign.start,
        keyboardType: inputType,
        obscureText: obscure,
        enableSuggestions: suggestions,
        controller: controller,
      ),
    );
  }
}
