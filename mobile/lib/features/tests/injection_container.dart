import 'package:clean_architecture_template/features/tests/data/datasource/home_datasource.dart';
import 'package:clean_architecture_template/features/tests/data/datasource/test_datasource.dart';
import 'package:clean_architecture_template/features/tests/data/repositories/home_repository_impl.dart';
import 'package:clean_architecture_template/features/tests/data/repositories/test_repository_impl.dart';
import 'package:clean_architecture_template/features/tests/domain/repositories/home_repository.dart';
import 'package:clean_architecture_template/features/tests/domain/repositories/test_repository.dart';
import 'package:clean_architecture_template/features/tests/presentation/blocs/ai_chat/ai_chat_cubit.dart';
import 'package:clean_architecture_template/features/tests/presentation/blocs/home/home_cubit.dart';
import 'package:clean_architecture_template/features/tests/presentation/blocs/test/test_cubit.dart';
import 'package:clean_architecture_template/injection_container.dart';
import 'package:dio/dio.dart';

mixin ChatsInjector on Injector {
  @override
  Future<void> init() async {
    await super.init();
    final Dio dio = sl<Dio>(instanceName: globalDio);

    // cubits
    sl.registerLazySingleton(() => HomeCubit(repository: sl()));

    sl.registerLazySingleton(() => TestCubit(repository: sl()));

    sl.registerLazySingleton(() => QuestionAiChatCubit(repository: sl(), questionId: ''));

    sl.registerLazySingleton(() => GeneralAiChatCubit(repository: sl()));

    // use cases

    // repositories
    sl.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(homeDatasource: sl()));
        
    sl.registerLazySingleton<TestRepository>(
        () => TestRepositoryImpl(testDatasource: sl()));

    // data sources
    sl.registerLazySingleton<HomeDatasource>(
        () => HomeDatasourceImpl(dio: dio));

    sl.registerLazySingleton<TestDatasource>(
        () => TestDatasourceImpl(dio: dio));
  }
}
