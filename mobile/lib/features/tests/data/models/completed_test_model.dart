import 'package:clean_architecture_template/features/tests/domain/entities/completed_test.dart';

class CompletedTestModel extends CompletedTest {
  CompletedTestModel({
    required super.id,
    required super.testId,
    required super.testTitle,
    required super.testDifficulty,
    required super.languageName,
    required super.languageCode,
    required super.scoreObtained,
    required super.completedAt,
  });

  factory CompletedTestModel.fromJson(Map<String, dynamic> json) {
    return CompletedTestModel(
      id: json['id'],
      testId: json['test'],
      testTitle: json['test_title'],
      testDifficulty: json['test_difficulty'],
      languageName: json['language_name'],
      languageCode: json['language_code'],
      scoreObtained: json['score_obtained'],
      completedAt: json['completed_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'test': testId,
      'test_title': testTitle,
      'test_difficulty': testDifficulty,
      'language_name': languageName,
      'language_code': languageCode,
      'score_obtained': scoreObtained,
      'completed_at': completedAt,
    };
  }
} 