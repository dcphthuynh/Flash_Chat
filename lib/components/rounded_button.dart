import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Function onPressed;
  final String buttonTitle;

  RoundedButton({@required this.buttonTitle, @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        child: MaterialButton(
            onPressed: onPressed,
            padding: EdgeInsets.all(25),
            height: 42.0,
            child: Text(
              buttonTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
