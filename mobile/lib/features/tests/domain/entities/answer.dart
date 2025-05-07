/// Represents a user's answer to a test question.
/// 
/// The answer can be one of several types:
/// - Single choice (id)
/// - Text input (text)
/// - Ordering (order)
/// - Code correction (correctedCode)
class Answer {
  final int questionId;
  final Map<String, dynamic> answer;

  Answer({
    required this.questionId,
    required this.answer,
  });

  /// Creates an Answer with a single choice selection
  factory Answer.singleChoice(int questionId, String choiceId) {
    return Answer(
      questionId: questionId,
      answer: {'id': choiceId},
    );
  }

  /// Creates an Answer with a text input
  factory Answer.text(int questionId, String text) {
    return Answer(
      questionId: questionId,
      answer: {'text': text},
    );
  }

  /// Creates an Answer with an ordering of items
  factory Answer.ordering(int questionId, List<int> order) {
    return Answer(
      questionId: questionId,
      answer: {'order': order},
    );
  }

  /// Creates an Answer with corrected code
  factory Answer.code(int questionId, String correctedCode) {
    return Answer(
      questionId: questionId,
      answer: {'correctedCode': correctedCode},
    );
  }

  /// Converts the Answer to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'answer': answer,
    };
  }

  /// Creates an Answer from a JSON map
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionId: json['question_id'],
      answer: json['answer'],
    );
  }

  @override
  String toString() {
    return 'Answer(questionId: $questionId, answer: $answer)';
  }
}
