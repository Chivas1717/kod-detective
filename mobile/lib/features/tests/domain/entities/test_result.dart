/// Represents the result of a submitted test.
class TestResult {
  final String message;
  final int correctAnswers;
  final int totalQuestions;
  final int scoreObtained;
  final int totalScore;

  TestResult({
    required this.message,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.scoreObtained,
    required this.totalScore,
  });

  /// Calculates the percentage score
  double get percentageScore => 
      totalScore > 0 ? (scoreObtained / totalScore) * 100 : 0;

  /// Determines if the test was passed (e.g., score > 70%)
  bool get isPassed => percentageScore >= 70;

  @override
  String toString() {
    return 'TestResult(correctAnswers: $correctAnswers/$totalQuestions, score: $scoreObtained/$totalScore)';
  }
} 