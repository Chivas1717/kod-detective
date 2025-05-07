import 'package:clean_architecture_template/features/auth/data/models/user_model.dart';
import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_template/features/tests/data/models/completed_test_model.dart';
import 'package:clean_architecture_template/features/tests/data/models/language_model.dart';
import 'package:clean_architecture_template/features/tests/data/models/test_model.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/completed_test.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/language.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/test.dart';
import 'package:dio/dio.dart';

abstract class HomeDatasource {
  Future<List<User>> getLeaderBoard();

  Future<List<Test>> getTests();

  Future<List<Language>> getLanguages();

  Future<List<CompletedTest>> getCompletedTests();

  Future<User> getUserProfile(int userId);

  Future<List<CompletedTest>> getUserCompletedTests(int userId);
}

class HomeDatasourceImpl extends HomeDatasource {
  HomeDatasourceImpl({
    required this.dio,
  });

  final Dio dio;

  @override
  Future<List<User>> getLeaderBoard() async {
    final result = await dio.get(
      '/api/leaderboard/',
    );
    List<User> leaderBoard = List.from(result.data)
        .map((e) => UserModel.fromJson(e))
        .toList();

    return leaderBoard;
  }

  @override
  Future<List<Test>> getTests() async {
    final result = await dio.get('/api/tests/');

    List<Test> tests =
        List.from(result.data).map((e) => TestModel.fromJson(e)).toList();

    return tests;
  }

  @override
  Future<List<Language>> getLanguages() async {
    final result = await dio.get('/api/languages/');
    
    List<Language> languages =
        List.from(result.data).map((e) => LanguageModel.fromJson(e)).toList();
    
    return languages;
  }

  @override
  Future<List<CompletedTest>> getCompletedTests() async {
    final result = await dio.get('/api/completed-tests/');
    
    List<CompletedTest> completedTests = List.from(result.data)
        .map((e) => CompletedTestModel.fromJson(e))
        .toList();
    
    return completedTests;
  }

  @override
  Future<User> getUserProfile(int userId) async {
    final result = await dio.get('/api/users/$userId/');
    
    return UserModel.fromJson(result.data);
  }

  @override
  Future<List<CompletedTest>> getUserCompletedTests(int userId) async {
    final result = await dio.get('/api/users/$userId/completed-tests/');
    
    List<CompletedTest> completedTests = List.from(result.data)
        .map((e) => CompletedTestModel.fromJson(e))
        .toList();
    
    return completedTests;
  }
}
