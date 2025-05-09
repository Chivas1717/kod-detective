part of 'ai_chat_cubit.dart';

@immutable
abstract class AiChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AiChatInitial extends AiChatState {}

class AiChatLoading extends AiChatState {
  final String? userMessage;

  AiChatLoading({this.userMessage});

  @override
  List<Object?> get props => [userMessage];
}

class AiChatSuccess extends AiChatState {
  final String userMessage;
  final String aiResponse;

  AiChatSuccess({
    required this.userMessage,
    required this.aiResponse,
  });

  @override
  List<Object?> get props => [userMessage, aiResponse];
}

class AiChatError extends AiChatState {
  final String message;

  AiChatError({required this.message});

  @override
  List<Object?> get props => [message];
} 