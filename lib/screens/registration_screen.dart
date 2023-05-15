import 'package:flast_chat/components/rounded_button.dart';
import 'package:flast_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flast_chat/components/input_text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  bool showLoading = false;
  String warningText;
  bool canSee = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ModalProgressHUD(
        inAsyncCall: showLoading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              InputTextField(
                hintText: 'Enter your email',
                onChanged: (value) {
                  email = value;
                },
                isPassword: false,
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 12.0,
              ),
              InputTextField(
                hintText: 'Enter your password',
                onChanged: (value) {
                  password = value;
                },
                isPassword: true,
                inputType: TextInputType.none,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: RoundedButton(
                  buttonTitle: 'Register',
                  onPressed: () async {
                    setState(() {
                      showLoading = true;
                    });
                    await Future.delayed(Duration(seconds: 1));
                    setState(() {
                      showLoading = false;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }

                      setState(() {
                        showLoading = false;
                      });
                    } on FirebaseAuthException catch (e) {
                      setState(
                        () {
                          canSee = true;
                          switch (e.code) {
                            case 'invalid-email':
                              warningText =
                                  'Please re-enter a well formatted email';
                              break;
                            case 'email-already-in-use':
                              warningText =
                                  'Email address already in use. Please try a different email address.';
                              break;
                            case 'weak-password':
                              warningText =
                                  'Password must be at least 8 characters long and contain at least 1 uppercase letter, 1 lowercase letter, 1 number.';
                              break;
                          }
                        },
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: canSee
                    ? Text(
                        warningText,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
