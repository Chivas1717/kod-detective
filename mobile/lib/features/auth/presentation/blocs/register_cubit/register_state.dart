part of 'register_cubit.dart';

@immutable
abstract class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String errorMessage;    
  final int errorCode;

  const RegisterFailure({required this.errorMessage, required this.errorCode});
}

class RegisterSuccess extends RegisterState {
  final User user;
  const RegisterSuccess({required this.user});
}

class RegisterLoading extends RegisterState {}
