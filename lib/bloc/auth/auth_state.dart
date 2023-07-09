part of 'auth_bloc.dart';

// @immutable
abstract class AuthState {}

class AuthStateLogin extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateLogout extends AuthState {}

class AuthStateError extends AuthState {
  AuthStateError(this.msg);
  final String msg;
}
