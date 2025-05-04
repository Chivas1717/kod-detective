import 'package:clean_architecture_template/core/helper/type_aliases.dart';
import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  FutureFailable<User> login(String username, String password);
  FutureFailable<User> register(String username, String password, String email);
  FutureFailable<bool> logOut();
  FutureFailable<User> getUser();
  FutureFailable<User> updateUser({String? username});
}
