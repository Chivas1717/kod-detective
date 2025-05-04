import 'package:clean_architecture_template/core/error/failures.dart';
import 'package:clean_architecture_template/core/error/repository_request_handler.dart';
import 'package:clean_architecture_template/core/helper/type_aliases.dart';
import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_template/features/chats/data/datasource/home_datasource.dart';
import 'package:clean_architecture_template/features/chats/domain/entities/test.dart';
import 'package:clean_architecture_template/features/chats/domain/repositories/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeDatasource homeDatasource;

  HomeRepositoryImpl({
    required this.homeDatasource,
  });

  // @override
  // FutureFailable<void> createChat(userId) {
  //   return RepositoryRequestHandler<void>()(
  //     request: () => homeDatasource.createChat(userId),
  //     defaultFailure: ServerFailure(),
  //   );
  // }

  @override
  FutureFailable<List<Test>> getTests() {
    return RepositoryRequestHandler<List<Test>>()(
      request: () => homeDatasource.getTests(),
      defaultFailure: ServerFailure(),
    );
  }

  @override
  FutureFailable<List<User>> getLeaderBoard() {
    return RepositoryRequestHandler<List<User>>()(
      request: () => homeDatasource.getLeaderBoard(),
      defaultFailure: ServerFailure(),
    );
  }
}
