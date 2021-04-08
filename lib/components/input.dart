import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  Input(
      {required this.label,
      this.inputType = TextInputType.text,
      this.obscure = false, required this.controller});
  final String label;
  final TextInputType inputType;
  final bool obscure;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
        keyboardType: inputType,
        obscureText: obscure,
        controller: controller,
        style: TextStyle(fontSize: 19.5),
      ),
    );
  }
}
