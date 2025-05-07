class CompletedTest {
  final int id;
  final int testId;
  final String testTitle;
  final String testDifficulty;
  final String languageName;
  final String languageCode;
  final int scoreObtained;
  final String completedAt;

  CompletedTest({
    required this.id,
    required this.testId,
    required this.testTitle,
    required this.testDifficulty,
    required this.languageName,
    required this.languageCode,
    required this.scoreObtained,
    required this.completedAt,
  });

  // Helper method to format the completion date
  String get formattedDate {
    final dateTime = DateTime.parse(completedAt);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
} 