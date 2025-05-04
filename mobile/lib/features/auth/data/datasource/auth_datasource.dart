import 'package:clean_architecture_template/core/helper/shared_preferences.dart';
import 'package:clean_architecture_template/features/auth/data/models/user_model.dart';
import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:dio/dio.dart';

abstract class AuthDatasource {
  Future<User> login(String username, String password);
  Future<User> register(String username, String password, String email);
  Future<bool> logOut();
  Future<User> getUser();
  Future<User> updateUser({String? username});
}

class AuthDatasourceImpl extends AuthDatasource {
  AuthDatasourceImpl({
    required this.dio,
    required this.sharedPreferencesRepository,
  });

  final Dio dio;
  final SharedPreferencesRepository sharedPreferencesRepository;

  @override
  Future<User> login(String username, String password) async {
    final result = await dio.post(
      '/api/auth/login/',
      data: {
        'username': username,
        'password': password,
      },
    );
    
    final User user = UserModel.fromJson(result.data);
    
    // Store token
    if (user.token != null) {
      await sharedPreferencesRepository.writeString(
        key: SharedPreferencesKeys.token,
        value: user.token!,
      );
    }

    return user;
  }

  @override
  Future<User> register(String username, String password, String email) async {
    final result = await dio.post(
      '/api/auth/register/',
      data: {
        'username': username,
        'password': password,
        'email': email,
      },
    );
    
    final User user = UserModel.fromJson(result.data);
    
    // Store token
    if (user.token != null) {
      await sharedPreferencesRepository.writeString(
        key: SharedPreferencesKeys.token,
        value: user.token!,
      );
    }

    return user;
  }

  @override
  Future<bool> logOut() async {
    await sharedPreferencesRepository.removeString(key: SharedPreferencesKeys.token);
    return true;
  }

  @override
  Future<User> getUser() async {
    final result = await dio.get('/api/users/self/');
    return UserModel.fromJson(result.data);
  }

  @override
  Future<User> updateUser({String? username}) async {
    final result = await dio.patch(
      '/api/users/update/',
      data: {"username": username},
    );

    return UserModel.fromJson(result.data);
  }
}
