import 'package:flutter/material.dart';
import '/constants.dart';

class InputTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextInputType inputType;
  final TextEditingController? controller;

  InputTextField({
    required this.hintText,
    required this.isPassword,
    required this.inputType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      obscureText: isPassword,
      style: TextStyle(color: Colors.black),
      decoration: kTextFieldDecoration.copyWith(hintText: hintText),
    );
  }
}
