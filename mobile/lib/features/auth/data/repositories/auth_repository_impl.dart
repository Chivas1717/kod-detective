import 'package:clean_architecture_template/core/error/failures.dart';
import 'package:clean_architecture_template/core/error/repository_request_handler.dart';
import 'package:clean_architecture_template/core/helper/type_aliases.dart';
import 'package:clean_architecture_template/features/auth/data/datasource/auth_datasource.dart';
import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_template/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl({
    required this.authDatasource,
  });

  @override
  FutureFailable<User> login(String username, String password) {
    return RepositoryRequestHandler<User>()(
      request: () => authDatasource.login(username, password),
      defaultFailure: LogInFailure(),
    );
  }

  @override
  FutureFailable<bool> logOut() {
    return RepositoryRequestHandler<bool>()(
      request: () => authDatasource.logOut(),
      defaultFailure: LogInFailure(),
    );
  }

  @override
  FutureFailable<User> register(String username, String password, String email) {
    return RepositoryRequestHandler<User>()(
      request: () => authDatasource.register(username, password, email),
      defaultFailure: LogInFailure(),
    );
  }

  @override
  FutureFailable<User> getUser() {
    return RepositoryRequestHandler<User>()(
      request: () => authDatasource.getUser(),
      defaultFailure: ProfileFailure(),
    );
  }

  // @override
  // FutureFailable<User> getOtherUser(int id) {
  //   return RepositoryRequestHandler<User>()(
  //     request: () => authDatasource.getOtherUser(id),
  //     defaultFailure: ProfileFailure(),
  //   );
  // }

  @override
  FutureFailable<User> updateUser({String? username}) {
    return RepositoryRequestHandler<User>()(
      request: () => authDatasource.updateUser(username: username),
      defaultFailure: ProfileFailure(),
    );
  }
}
