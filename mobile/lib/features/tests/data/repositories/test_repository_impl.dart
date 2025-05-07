import 'package:clean_architecture_template/core/error/failures.dart';
import 'package:clean_architecture_template/core/error/repository_request_handler.dart';
import 'package:clean_architecture_template/core/helper/type_aliases.dart';
import 'package:clean_architecture_template/features/tests/data/datasource/test_datasource.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/answer.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/question.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/test_result.dart';
import 'package:clean_architecture_template/features/tests/domain/repositories/test_repository.dart';

class TestRepositoryImpl implements TestRepository {
  final TestDatasource testDatasource;

  TestRepositoryImpl({
    required this.testDatasource,
  });

  @override
  FutureFailable<List<Question>> getTestQuestions(String testId) {
    return RepositoryRequestHandler<List<Question>>()(
      request: () => testDatasource.getTestQuestions(testId),
      defaultFailure: ServerFailure(),
    );
  }

  @override
  FutureFailable<TestResult> submitTest(
    String testId, 
    List<Answer> answers, 
    {int timeSpent = 0, bool usedHint = false}
  ) {
    return RepositoryRequestHandler<TestResult>()(
      request: () => testDatasource.submitTest(
        testId, 
        answers, 
        timeSpent: timeSpent, 
        usedHint: usedHint
      ),
      defaultFailure: ServerFailure(),
    );
  }
}
