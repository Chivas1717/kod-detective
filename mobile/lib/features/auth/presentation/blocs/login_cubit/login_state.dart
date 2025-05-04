part of 'login_cubit.dart';

@immutable
abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {}

class LoginFailure extends LoginState {
  final String errorMessage;
  final int errorCode;

  const LoginFailure({required this.errorMessage, required this.errorCode});
}

class LoginSuccess extends LoginState {
  final User user;
  const LoginSuccess({required this.user});
}

class LoginLoading extends LoginState {}
