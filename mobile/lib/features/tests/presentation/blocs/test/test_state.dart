part of 'test_cubit.dart';

@immutable
abstract class TestState {}

/// Initial state when the test hasn't been loaded yet
class TestInitial extends TestState {}

/// State when test data is being loaded
class TestLoading extends TestState {}

/// State when there's an error loading or submitting the test
class TestFailure extends TestState {
  final String message;

  TestFailure({required this.message});
}

/// State when questions are loaded and test is in progress
class TestInProgress extends TestState {
  final String testId;
  final List<Question> questions;
  final Map<int, dynamic> userAnswers;
  final int currentQuestionIndex;
  final DateTime startTime;
  final bool usedHint;

  TestInProgress({
    required this.testId,
    required this.questions,
    this.userAnswers = const {},
    this.currentQuestionIndex = 0,
    required this.startTime,
    this.usedHint = false,
  });

  TestInProgress copyWith({
    String? testId,
    List<Question>? questions,
    Map<int, dynamic>? userAnswers,
    int? currentQuestionIndex,
    DateTime? startTime,
    bool? usedHint,
  }) {
    return TestInProgress(
      testId: testId ?? this.testId,
      questions: questions ?? this.questions,
      userAnswers: userAnswers ?? this.userAnswers,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      startTime: startTime ?? this.startTime,
      usedHint: usedHint ?? this.usedHint,
    );
  }

  Question get currentQuestion => 
      questions.isNotEmpty ? questions[currentQuestionIndex] : questions.first;

  bool get isComplete => userAnswers.length == questions.length;

  int get timeSpentInSeconds => 
      DateTime.now().difference(startTime).inSeconds;
}

/// State when test has been submitted and results are available
class TestCompleted extends TestState {
  final TestResult result;
  final List<Question> questions;
  final Map<int, dynamic> userAnswers;
  final String testId;

  TestCompleted({
    required this.result,
    required this.questions,
    required this.userAnswers,
    required this.testId,
  });
}
