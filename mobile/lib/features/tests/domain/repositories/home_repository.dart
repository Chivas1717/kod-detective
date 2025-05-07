import 'package:clean_architecture_template/core/helper/type_aliases.dart';
import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/completed_test.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/language.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/test.dart';

abstract class HomeRepository {
  FutureFailable<List<User>> getLeaderBoard();
  FutureFailable<List<Test>> getTests();
  FutureFailable<List<Language>> getLanguages();
  FutureFailable<List<CompletedTest>> getCompletedTests();
  FutureFailable<User> getUserProfile(int userId);
  FutureFailable<List<CompletedTest>> getUserCompletedTests(int userId);
}
