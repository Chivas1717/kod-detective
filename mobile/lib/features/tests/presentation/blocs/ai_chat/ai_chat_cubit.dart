import 'package:bloc/bloc.dart';
import 'package:clean_architecture_template/features/tests/domain/repositories/home_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'ai_chat_state.dart';

abstract class AiChatCubit extends Cubit<AiChatState> {
  final HomeRepository repository;

  AiChatCubit({required this.repository}) : super(AiChatInitial());

  Future<void> sendMessage(String message);
  void clearChat();
}

class QuestionAiChatCubit extends AiChatCubit {
  String questionId;

  QuestionAiChatCubit({
    required super.repository,
    required this.questionId,
  });

  @override
  Future<void> sendMessage(String message) async {
    emit(AiChatLoading(userMessage: message));

    final result = await repository.askQuestionAi(questionId, message);

    result.fold(
      (failure) => emit(AiChatError(message: failure.errorMessage)),
      (response) => emit(AiChatSuccess(
        userMessage: message,
        aiResponse: response,
      )),
    );
  }

  @override
  void clearChat() {
    emit(AiChatInitial());
  }

  void updateQuestionId(String newQuestionId) {
    if (questionId != newQuestionId) {
      // Only update if the ID has changed
      questionId = newQuestionId;
      // Optionally clear the chat when switching questions
      clearChat();
    }
  }
}

class GeneralAiChatCubit extends AiChatCubit {
  GeneralAiChatCubit({required super.repository});

  @override
  Future<void> sendMessage(String message) async {
    emit(AiChatLoading(userMessage: message));

    final result = await repository.askGeneralAi(message);

    result.fold(
      (failure) => emit(AiChatError(message: failure.errorMessage)),
      (response) => emit(AiChatSuccess(
        userMessage: message,
        aiResponse: response,
      )),
    );
  }

  @override
  void clearChat() {
    emit(AiChatInitial());
  }
} 