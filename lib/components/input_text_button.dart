import 'package:flutter/material.dart';
import 'package:flast_chat/constants.dart';

class InputTextField extends StatelessWidget {
  final String hintText;
  final Function onChanged;
  final bool isPassword;
  final inputType;
  final TextEditingController controller;

  InputTextField({
    @required this.hintText,
    @required this.onChanged,
    this.isPassword,
    this.inputType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      obscureText: isPassword,
      style: TextStyle(color: Colors.black),
      onChanged: onChanged,
      decoration: kTextFieldDecoration.copyWith(hintText: hintText),
    );
  }
}
