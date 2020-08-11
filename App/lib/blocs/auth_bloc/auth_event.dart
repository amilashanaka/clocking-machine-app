part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginAuthEvent extends AuthEvent {
  final User user;

  LoginAuthEvent(this.user);
}

class LogoutAuthEvent extends AuthEvent {}
