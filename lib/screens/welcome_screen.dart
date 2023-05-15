import 'package:flast_chat/components/square_tile.dart';
import 'package:flast_chat/screens/chat_screen.dart';
import 'package:flast_chat/screens/registration_screen.dart';
import 'package:flast_chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flast_chat/components/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flast_chat/components/input_text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

// If you want to animate 1 thing then use SingleTickerProviderStateMixin, in the other hand you use TickerProviderStateMixin.
class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  bool showLoading = false;
  bool canSee = false;
  String warningText;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ModalProgressHUD(
        inAsyncCall: showLoading,
        child: Padding(
          padding: EdgeInsets.only(right: 24.0, left: 24, top: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Opacity(
                opacity: animation.value,
                child: Row(
                  children: <Widget>[
                    Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image.asset('images/logo.png'),
                        height: 60.0,
                      ),
                    ),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Flash Chat',
                          textStyle: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87),
                          speed: Duration(milliseconds: 200),
                        ),
                      ],
                      pause: const Duration(milliseconds: 1000),
                      totalRepeatCount: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 48.0),
              InputTextField(
                controller: userNameController,
                hintText: 'Enter your email',
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                isPassword: false,
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10.0),
              InputTextField(
                controller: passwordController,
                hintText: 'Enter your password',
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                isPassword: true,
                inputType: TextInputType.text,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              RoundedButton(
                buttonTitle: 'Sign In',
                onPressed: () async {
                  setState(() {
                    showLoading = true;
                  });
                  await Future.delayed(Duration(seconds: 1));
                  setState(() {
                    showLoading = false;
                  });
                  try {
                    final newUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    // print(newUser);
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                      setState(() {
                        showLoading = false;
                      });
                    }
                  } on FirebaseAuthException catch (e) {
                    setState(
                      () {
                        canSee = true;
                        switch (e.code) {
                          case 'invalid-email':
                            warningText =
                                'Please re-enter a well formatted email';
                            break;
                          case 'wrong-password':
                            warningText =
                                'Incorrect email or password. Please try again.';
                            break;
                          case 'user-not-found':
                            warningText =
                                'Incorrect email or password. Please try again.';
                            break;
                        }
                      },
                    );
                  }
                },
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
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                    ),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    imgPath: 'images/Google.svg.png',
                    onTap: () {
                      AuthService().signInWithGoogle();
                    },
                  ),
                  SizedBox(width: 25),
                  SquareTile(
                    imgPath: 'images/apple.png',
                    onTap: () {},
                  )
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?'),
                  TextButton(
                      child: Text('Register now',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w900)),
                      onPressed: () {
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
