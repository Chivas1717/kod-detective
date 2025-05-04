import 'package:clean_architecture_template/features/chats/data/datasource/home_datasource.dart';
import 'package:clean_architecture_template/features/chats/data/repositories/home_repository_impl.dart';
import 'package:clean_architecture_template/features/chats/domain/repositories/home_repository.dart';
import 'package:clean_architecture_template/features/chats/presentation/blocs/home/home_cubit.dart';
import 'package:clean_architecture_template/injection_container.dart';
import 'package:dio/dio.dart';

mixin ChatsInjector on Injector {
  @override
  Future<void> init() async {
    await super.init();
    final Dio dio = sl<Dio>(instanceName: globalDio);

    // cubits
    sl.registerLazySingleton(() => HomeCubit(repository: sl()));

    // use cases

    // repositories
    sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(homeDatasource: sl()));

    // data sources
    sl.registerLazySingleton<HomeDatasource>(
        () => HomeDatasourceImpl(dio: dio));
  }
}
