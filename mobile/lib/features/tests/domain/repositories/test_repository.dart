import 'package:clean_architecture_template/core/helper/type_aliases.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/answer.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/question.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/test_result.dart';

abstract class TestRepository {
  /// Fetches all questions for a specific test
  FutureFailable<List<Question>> getTestQuestions(String testId);
  
  /// Submits answers for a test and returns the result
  FutureFailable<TestResult> submitTest(
    String testId, 
    List<Answer> answers, 
    {int timeSpent, bool usedHint}
  );
}
