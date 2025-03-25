import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/constants.dart';
import '/components/rounded_button.dart';
import '/components/input_text_button.dart';
import '/components/square_tile.dart';
import '/screens/chat_screen.dart';
import '/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushNamed(context, ChatScreen.id);
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is AuthLoading,
            child: Padding(
              padding: EdgeInsets.only(right: 24.0, left: 24, top: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
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
                  SizedBox(height: 48.0),
                  InputTextField(
                    controller: userNameController,
                    hintText: 'Enter your email',
                    isPassword: false,
                    inputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10.0),
                  InputTextField(
                    controller: passwordController,
                    hintText: 'Enter your password',
                    isPassword: true,
                    inputType: TextInputType.text,
                  ),
                  SizedBox(height: 10.0),
                  RoundedButton(
                    buttonTitle: 'Sign In',
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            SignInWithEmailEvent(
                              userNameController.text,
                              passwordController.text,
                            ),
                          );
                    },
                  ),
                  if (state is AuthFailure)
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        state.error,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                          child:
                              Divider(thickness: 0.5, color: Colors.grey[400])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Text('Or continue with',
                            style: TextStyle(color: Colors.black87)),
                      ),
                      Expanded(
                          child:
                              Divider(thickness: 0.5, color: Colors.grey[400])),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(
                        imgPath: 'images/Google.svg.png',
                        onTap: () => context
                            .read<AuthBloc>()
                            .add(SignInWithGoogleEvent()),
                      ),
                      SizedBox(width: 25),
                      SquareTile(imgPath: 'images/apple.png', onTap: () {}),
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
                                color: Colors.blue,
                                fontWeight: FontWeight.w900)),
                        onPressed: () =>
                            Navigator.pushNamed(context, RegistrationScreen.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
