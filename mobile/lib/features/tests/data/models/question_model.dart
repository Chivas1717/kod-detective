import '../../domain/entities/question.dart';

/// Data model representation of a Question entity.
///
/// This class extends the domain entity and provides additional
/// functionality for data layer operations.
class QuestionModel extends Question {
  QuestionModel({
    required super.id,
    required super.type,
    required super.prompt,
    super.hint,
    super.clue,
    required super.metadata,
    required super.correctAnswer,
  });

  /// Creates a QuestionModel from a domain entity
  factory QuestionModel.fromEntity(Question question) {
    return QuestionModel(
      id: question.id,
      type: question.type,
      prompt: question.prompt,
      hint: question.hint,
      clue: question.clue,
      metadata: question.metadata,
      correctAnswer: question.correctAnswer,
    );
  }

  /// Creates a QuestionModel from a JSON map
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      type: json['type'],
      prompt: json['prompt'],
      hint: json['hint'],
      clue: json['clue'],
      metadata: json['metadata'] ?? {},
      correctAnswer: json['correct_answer'],
    );
  }

  /// Converts the QuestionModel to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'prompt': prompt,
      'hint': hint,
      'clue': clue,
      'metadata': metadata,
      'correct_answer': correctAnswer,
    };
  }

  /// Creates a copy of this QuestionModel with the given fields replaced
  QuestionModel copyWith({
    int? id,
    String? type,
    String? prompt,
    String? hint,
    String? clue,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? correctAnswer,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      prompt: prompt ?? this.prompt,
      hint: hint ?? this.hint,
      clue: clue ?? this.clue,
      metadata: metadata ?? this.metadata,
      correctAnswer: correctAnswer ?? this.correctAnswer,
    );
  }

  /// Creates a single choice question model
  factory QuestionModel.singleChoice({
    required int id,
    required String prompt,
    String? hint,
    String? clue,
    required List<Map<String, dynamic>> options,
    required String correctOptionId,
  }) {
    return QuestionModel(
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

  /// Creates a fill-in-the-blank question model
  factory QuestionModel.blank({
    required int id,
    required String prompt,
    String? hint,
    String? clue,
    required String correctText,
  }) {
    return QuestionModel(
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

  /// Creates an ordering question model
  factory QuestionModel.order({
    required int id,
    required String prompt,
    String? hint,
    String? clue,
    required List<Map<String, dynamic>> options,
    required List<int> correctOrder,
  }) {
    return QuestionModel(
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

  /// Creates a code tracing question model
  factory QuestionModel.trace({
    required int id,
    required String prompt,
    String? hint,
    String? clue,
    required List<Map<String, dynamic>> options,
    required String correctOptionId,
  }) {
    return QuestionModel(
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

  /// Creates a code debugging question model
  factory QuestionModel.debug({
    required int id,
    required String prompt,
    String? hint,
    String? clue,
    required String originalCode,
    required String correctedCode,
  }) {
    return QuestionModel(
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
}
