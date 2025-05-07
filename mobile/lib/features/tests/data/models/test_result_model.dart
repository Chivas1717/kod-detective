import '../../domain/entities/test_result.dart';

/// Data model representation of a TestResult entity.
class TestResultModel extends TestResult {
  TestResultModel({
    required String message,
    required int correctAnswers,
    required int totalQuestions,
    required int scoreObtained,
    required int totalScore,
  }) : super(
          message: message,
          correctAnswers: correctAnswers,
          totalQuestions: totalQuestions,
          scoreObtained: scoreObtained,
          totalScore: totalScore,
        );

  /// Creates a TestResultModel from a domain entity
  factory TestResultModel.fromEntity(TestResult result) {
    return TestResultModel(
      message: result.message,
      correctAnswers: result.correctAnswers,
      totalQuestions: result.totalQuestions,
      scoreObtained: result.scoreObtained,
      totalScore: result.totalScore,
    );
  }

  /// Creates a TestResultModel from a JSON map
  factory TestResultModel.fromJson(Map<String, dynamic> json) {
    return TestResultModel(
      message: json['message'],
      correctAnswers: json['correct_answers'],
      totalQuestions: json['total_questions'],
      scoreObtained: json['score_obtained'],
      totalScore: json['total_score'],
    );
  }

  /// Converts the TestResultModel to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'correct_answers': correctAnswers,
      'total_questions': totalQuestions,
      'score_obtained': scoreObtained,
      'total_score': totalScore,
    };
  }

  /// Creates a copy of this TestResultModel with the given fields replaced
  TestResultModel copyWith({
    String? message,
    int? correctAnswers,
    int? totalQuestions,
    int? scoreObtained,
    int? totalScore,
  }) {
    return TestResultModel(
      message: message ?? this.message,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      scoreObtained: scoreObtained ?? this.scoreObtained,
      totalScore: totalScore ?? this.totalScore,
    );
  }
} 