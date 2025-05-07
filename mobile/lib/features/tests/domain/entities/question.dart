/// Represents a test question with various possible types.
///
/// Question types include:
/// - single: Multiple choice with one correct answer
/// - blank: Fill in the blank text answer
/// - order: Arrange items in correct order
/// - trace: Code tracing with multiple choice
/// - debug: Fix code with a corrected version
class Question {
  final int id;
  final String type;
  final String prompt;
  final String? hint;
  final String? clue;
  final Map<String, dynamic> metadata;
  final Map<String, dynamic> correctAnswer;

  Question({
    required this.id,
    required this.type,
    required this.prompt,
    this.hint,
    this.clue,
    required this.metadata,
    required this.correctAnswer,
  });

  /// Creates a single choice question
  factory Question.singleChoice({
    required int id,
    required String prompt,
    String? hint,
    String? clue,
    required List<Map<String, dynamic>> options,
    required String correctOptionId,
  }) {
    return Question(
      id: id,
      type: 'single',
      prompt: prompt,
      hint: hint,
      clue: clue,
      metadata: {
        'options': options,
      },
      correctAnswer: {
        'id': correctOptionId,
      },
    );
  }

  /// Creates a fill-in-the-blank question
  factory Question.blank({
    required int id,
    required String prompt,
    String? hint,
    String? clue,
    required String correctText,
  }) {
    return Question(
      id: id,
      type: 'blank',
      prompt: prompt,
      hint: hint,
      clue: clue,
      metadata: {},
      correctAnswer: {
        'text': correctText,
      },
    );
  }

  /// Creates an ordering question
  factory Question.order({
    required int id,
    required String prompt,
    String? hint,
    String? clue,
    required List<Map<String, dynamic>> options,
    required List<int> correctOrder,
  }) {
    return Question(
      id: id,
      type: 'order',
      prompt: prompt,
      hint: hint,
      clue: clue,
      metadata: {
        'options': options,
      },
      correctAnswer: {
        'order': correctOrder,
      },
    );
  }

  /// Creates a code tracing question
  factory Question.trace({
    required int id,
    required String prompt,
    String? hint,
    String? clue,
    required List<Map<String, dynamic>> options,
    required String correctOptionId,
  }) {
    return Question(
      id: id,
      type: 'trace',
      prompt: prompt,
      hint: hint,
      clue: clue,
      metadata: {
        'options': options,
      },
      correctAnswer: {
        'id': correctOptionId,
      },
    );
  }

  /// Creates a code debugging question
  factory Question.debug({
    required int id,
    required String prompt,
    String? hint,
    String? clue,
    required String originalCode,
    required String correctedCode,
  }) {
    return Question(
      id: id,
      type: 'debug',
      prompt: prompt,
      hint: hint,
      clue: clue,
      metadata: {
        'originalCode': originalCode,
      },
      correctAnswer: {
        'correctedCode': correctedCode,
      },
    );
  }

  @override
  String toString() {
    return 'Question(id: $id, type: $type, prompt: $prompt)';
  }
} 