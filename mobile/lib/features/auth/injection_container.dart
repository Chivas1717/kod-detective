import 'package:clean_architecture_template/features/auth/data/datasource/auth_datasource.dart';
import 'package:clean_architecture_template/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:clean_architecture_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:clean_architecture_template/features/auth/presentation/blocs/login_cubit/login_cubit.dart';
import 'package:clean_architecture_template/features/auth/presentation/blocs/register_cubit/register_cubit.dart';
import 'package:clean_architecture_template/features/auth/presentation/blocs/user_cubit/user_cubit.dart';
import 'package:clean_architecture_template/injection_container.dart';
import 'package:dio/dio.dart';

mixin AuthInjector on Injector {
  @override
  Future<void> init() async {
    await super.init();
    final Dio dio = sl<Dio>(instanceName: globalDio);

    // // cubits
    sl.registerFactory(() => LoginCubit(repository: sl()));
    sl.registerFactory(() => RegisterCubit(repository: sl()));

    sl.registerLazySingleton(() => UserCubit(
          repository: sl(),
          sharedPrefsRepository: sl(),
        ));

    // repositories
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authDatasource: sl(),
      ),
    );

    // data sources
    sl.registerLazySingleton<AuthDatasource>(
      () => AuthDatasourceImpl(
        dio: dio,
        sharedPreferencesRepository: sl(),
      ),
    );

    // use case
  }
}
