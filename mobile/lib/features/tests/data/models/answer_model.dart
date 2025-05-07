import '../../domain/entities/answer.dart';

/// Data model representation of an Answer entity.
/// 
/// This class extends the domain entity and provides additional
/// functionality for data layer operations.
class AnswerModel extends Answer {
  AnswerModel({
    required super.questionId,
    required super.answer,
  });

  /// Creates an AnswerModel with a single choice selection
  factory AnswerModel.singleChoice(int questionId, String choiceId) {
    return AnswerModel(
      questionId: questionId,
      answer: {'id': choiceId},
    );
  }

  /// Creates an AnswerModel with a text input
  factory AnswerModel.text(int questionId, String text) {
    return AnswerModel(
      questionId: questionId,
      answer: {'text': text},
    );
  }

  /// Creates an AnswerModel with an ordering of items
  factory AnswerModel.ordering(int questionId, List<int> order) {
    return AnswerModel(
      questionId: questionId,
      answer: {'order': order},
    );
  }

  /// Creates an AnswerModel with corrected code
  factory AnswerModel.code(int questionId, String correctedCode) {
    return AnswerModel(
      questionId: questionId,
      answer: {'correctedCode': correctedCode},
    );
  }

  /// Creates an AnswerModel from a domain entity
  factory AnswerModel.fromEntity(Answer answer) {
    return AnswerModel(
      questionId: answer.questionId,
      answer: answer.answer,
    );
  }

  /// Creates an AnswerModel from a JSON map
  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      questionId: json['question_id'],
      answer: json['answer'],
    );
  }

  /// Converts the AnswerModel to a JSON-compatible map
  @override
  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'answer': answer,
    };
  }

  /// Creates a copy of this AnswerModel with the given fields replaced
  AnswerModel copyWith({
    int? questionId,
    Map<String, dynamic>? answer,
  }) {
    return AnswerModel(
      questionId: questionId ?? this.questionId,
      answer: answer ?? this.answer,
    );
  }
}
