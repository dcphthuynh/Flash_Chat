import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color buttonBGColor;
  final Function onPressed;
  final String buttonTitle;

  RoundedButton(
      {@required this.buttonTitle,
      @required this.buttonBGColor,
      @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonBGColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonTitle,
          ),
        ),
      ),
    );
  }
}
