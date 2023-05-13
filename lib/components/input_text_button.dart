import 'package:flutter/material.dart';
import 'package:flast_chat/constants.dart';

class InputTextField extends StatelessWidget {
  final String hintText;

  InputTextField({@required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
        style: TextStyle(color: Colors.black),
        onChanged: (value) {
          //Do something with the user input.
        },
        decoration: kTextFieldDecoration.copyWith(hintText: hintText));
  }
}
