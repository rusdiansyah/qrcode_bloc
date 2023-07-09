part of 'auth_bloc.dart';

// @immutable
abstract class AuthEvent {}

class AuthEventLogin extends AuthEvent {
  AuthEventLogin(this.email, this.pass);
  final String email;
  final String pass;
}

class AuthEventLogout extends AuthEvent {}
