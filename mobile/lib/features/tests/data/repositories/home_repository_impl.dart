import 'package:clean_architecture_template/core/error/failures.dart';
import 'package:clean_architecture_template/core/error/repository_request_handler.dart';
import 'package:clean_architecture_template/core/helper/type_aliases.dart';
import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_template/features/tests/data/datasource/home_datasource.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/completed_test.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/language.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/test.dart';
import 'package:clean_architecture_template/features/tests/domain/repositories/home_repository.dart';
import 'package:clean_architecture_template/core/error/exceptions.dart';
import 'package:dartz/dartz.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeDatasource homeDatasource;

  HomeRepositoryImpl({
    required this.homeDatasource,
  });
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

  @override
  FutureFailable<List<Language>> getLanguages() {
    return RepositoryRequestHandler<List<Language>>()(
      request: () => homeDatasource.getLanguages(),
      defaultFailure: ServerFailure(),
    );
  }
  
  @override
  FutureFailable<List<CompletedTest>> getCompletedTests() {
    return RepositoryRequestHandler<List<CompletedTest>>()(
      request: () => homeDatasource.getCompletedTests(),
      defaultFailure: ServerFailure(),
    );
  }
  
  @override
  FutureFailable<User> getUserProfile(int userId) {
    return RepositoryRequestHandler<User>()(
      request: () => homeDatasource.getUserProfile(userId),
      defaultFailure: ServerFailure(),
    );
  }
  
  @override
  FutureFailable<List<CompletedTest>> getUserCompletedTests(int userId) {
    return RepositoryRequestHandler<List<CompletedTest>>()(
      request: () => homeDatasource.getUserCompletedTests(userId),
      defaultFailure: ServerFailure(),
    );
  }

  @override
  Future<Either<Failure, String>> askQuestionAi(String questionId, String prompt) async {
    try {
      final response = await homeDatasource.askQuestionAi(questionId, prompt);
      return Right(response);
    } on ServerException catch (_) {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> askGeneralAi(String prompt) async {
    try {
      final response = await homeDatasource.askGeneralAi(prompt);
      return Right(response);
    } on ServerException catch (_) {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
