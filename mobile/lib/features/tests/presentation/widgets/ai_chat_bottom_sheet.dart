import 'package:clean_architecture_template/features/tests/presentation/blocs/ai_chat/ai_chat_cubit.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/custom_test_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AiChatBottomSheet extends StatefulWidget {
  final AiChatCubit chatCubit;
  final String title;

  const AiChatBottomSheet({
    super.key,
    required this.chatCubit,
    required this.title,
  });

  @override
  State<AiChatBottomSheet> createState() => _AiChatBottomSheetState();
}

class _AiChatBottomSheetState extends State<AiChatBottomSheet> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      widget.chatCubit.sendMessage(message);
      _messageController.clear();
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF252538),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.smart_toy_outlined,
                  color: Color(0xFF7B61FF),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Chat messages
          Expanded(
            child: BlocBuilder<AiChatCubit, AiChatState>(
              bloc: widget.chatCubit,
              builder: (context, state) {
                if (state is AiChatInitial) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Питай мене, що тебе цікавить, юний детективе!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else if (state is AiChatLoading) {
                  return Column(
                    children: [
                      if (state.userMessage != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildUserMessage(state.userMessage!),
                        ),
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF7B61FF),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (state is AiChatSuccess) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildUserMessage(state.userMessage),
                        const SizedBox(height: 16),
                        _buildAiMessage(state.aiResponse),
                      ],
                    ),
                  );
                } else if (state is AiChatError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Помилка: ${state.message}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        CustomTestButton(
                          text: 'Спробувати знову',
                          isPrimary: true,
                          onPressed: () => widget.chatCubit.clearChat(),
                          icon: Icons.refresh,
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // Input field
          BlocBuilder<AiChatCubit, AiChatState>(
            bloc: widget.chatCubit,
            builder: (context, state) {
              final bool isInputEnabled = state is! AiChatLoading;
              
              return Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 42 + MediaQuery.of(context).viewInsets.bottom,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _focusNode,
                        enabled: isInputEnabled,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Напишіть повідомлення...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          filled: true,
                          fillColor: const Color(0xFF252538),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        onSubmitted: (value) {
                          if (isInputEnabled && value.trim().isNotEmpty) {
                            _sendMessage();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      mini: true,
                      backgroundColor: const Color(0xFF7B61FF),
                      onPressed: isInputEnabled ? _sendMessage : null,
                      child: Icon(
                        isInputEnabled ? Icons.send : Icons.hourglass_empty,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF7B61FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildAiMessage(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF3A3A4E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: MarkdownBody(
          data: message,
          styleSheet: MarkdownStyleSheet(
            p: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
            ),
            code: const TextStyle(
              color: Colors.white,
              backgroundColor: Color(0xFF252538),
              fontFamily: 'monospace',
              fontSize: 14,
            ),
            codeblockDecoration: BoxDecoration(
              color: const Color(0xFF252538),
              borderRadius: BorderRadius.circular(8),
            ),
            blockquote: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
            h1: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            h2: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            h3: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
} 