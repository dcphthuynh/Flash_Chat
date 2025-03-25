abstract class AuthEvent {}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailEvent(this.email, this.password);
}

class SignInWithGoogleEvent extends AuthEvent {}

class RegisterWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterWithEmailEvent(this.email, this.password);
}

class SignOutEvent extends AuthEvent {}
