import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.repository,
  }) : super(LoginInitial());

  final AuthRepository repository;

  void login(String username, String password) async {
    emit(LoginLoading());

    final loginResult = await repository.login(username, password);

    loginResult.fold(
      (failure) => emit(LoginFailure(
        errorMessage: failure.errorMessage,
        errorCode: failure.errorCode ?? 1,
      )),
      (result) => emit(LoginSuccess(user: result)),
    );
  }
}
