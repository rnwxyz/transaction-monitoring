part of 'auth_bloc.dart';

abstract class AuthEvent {}

class Login extends AuthEvent {
  final CredentionsModel credentions;

  Login(this.credentions);
}

class Logout extends AuthEvent {}

class CheckLogin extends AuthEvent {}
