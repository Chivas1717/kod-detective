import 'package:clean_architecture_template/features/tests/domain/entities/answer.dart';
import 'package:clean_architecture_template/features/tests/data/models/answer_model.dart';
import 'package:clean_architecture_template/features/tests/data/models/question_model.dart';
import 'package:clean_architecture_template/features/tests/data/models/test_result_model.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/question.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/test_result.dart';
import 'package:dio/dio.dart';

abstract class TestDatasource {
  Future<List<Question>> getTestQuestions(String testId);
  Future<TestResult> submitTest(String testId, List<Answer> answers, {int timeSpent, bool usedHint});
}

class TestDatasourceImpl implements TestDatasource {
  TestDatasourceImpl({
    required this.dio,
  });

  final Dio dio;

  @override
  Future<List<Question>> getTestQuestions(String testId) async {
    final result = await dio.get('/api/tests/$testId/questions/');
    
    List<Question> questions = List.from(result.data)
        .map((e) => QuestionModel.fromJson(e))
        .toList();
    
    return questions;
  }

  @override
  Future<TestResult> submitTest(
    String testId, 
    List<Answer> answers, 
    {int timeSpent = 0, bool usedHint = false}
  ) async {
    // Convert answers to JSON format
    final List<Map<String, dynamic>> answersJson = answers
        .map((answer) => AnswerModel.fromEntity(answer).toJson())
        .toList();
    
    // Prepare request payload
    final Map<String, dynamic> payload = {
      'answers': answersJson,
      'time_spent': timeSpent,
      'used_hint': usedHint,
    };
    
    // Submit test answers
    final response = await dio.post(
      '/api/tests/$testId/submit/',
      data: payload,
    );
    
    // Convert response to TestResult
    return TestResultModel.fromJson(response.data);
  }
}
