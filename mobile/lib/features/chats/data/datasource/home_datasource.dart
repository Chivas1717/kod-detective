import 'package:clean_architecture_template/features/auth/data/models/user_model.dart';
import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_template/features/chats/data/models/test_model.dart';
import 'package:clean_architecture_template/features/chats/domain/entities/test.dart';
import 'package:dio/dio.dart';

abstract class HomeDatasource {
  Future<List<User>> getLeaderBoard();

  Future<List<Test>> getTests();
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
    print('leaderboard result');
    print(result);
    List<User> leaderBoard = List.from(result.data)
        .map((e) => UserModel.fromJson(e))
        .toList();

    print('leaderboard');
    print(leaderBoard);

    return leaderBoard;
  }

  @override
  Future<List<Test>> getTests() async {
    final result = await dio.get('/api/tests/');

    List<Test> tests =
        List.from(result.data).map((e) => TestModel.fromJson(e)).toList();

    return tests;
  }
}
