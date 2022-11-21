part of 'auth_cubit.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class SignedOutState extends AuthState {
  const SignedOutState();
}

class SignedUpState extends AuthState {
  final String message;
  const SignedUpState(this.message);
}

class ProcessingState extends AuthState {
  const ProcessingState();
}

class LogInErrorState extends AuthState {
  final String message;
  const LogInErrorState(this.message);
}

class SignUpErrorState extends AuthState {
  final String message;
  const SignUpErrorState(this.message);
}

class LoggedInState extends AuthState {
  const LoggedInState();
}
