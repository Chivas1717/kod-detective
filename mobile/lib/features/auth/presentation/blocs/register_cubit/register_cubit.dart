import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({
    required this.repository,
  }) : super(RegisterInitial());

  final AuthRepository repository;

  void register(String username, String password, String email) async {
    emit(RegisterLoading());

    final registerResult = await repository.register(username, password, email);

    registerResult.fold(
      (failure) => emit(RegisterFailure(
        errorMessage: failure.errorMessage,
        errorCode: failure.errorCode ?? 1,
      )),
      (result) => emit(RegisterSuccess(user: result)),
    );
  }
}
