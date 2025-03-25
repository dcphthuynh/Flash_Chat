import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/components/rounded_button.dart';
import '/components/input_text_button.dart';
import '/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class RegistrationScreen extends StatelessWidget {
  static const String id = 'registration_screen';

  final emailController = TextEditingController();
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
                  SizedBox(height: 48.0),
                  InputTextField(
                    controller: emailController,
                    hintText: 'Enter your email',
                    isPassword: false,
                    inputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 12.0),
                  InputTextField(
                    controller: passwordController,
                    hintText: 'Enter your password',
                    isPassword: true,
                    inputType: TextInputType.none,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: RoundedButton(
                      buttonTitle: 'Register',
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              RegisterWithEmailEvent(
                                emailController.text,
                                passwordController.text,
                              ),
                            );
                      },
                    ),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
