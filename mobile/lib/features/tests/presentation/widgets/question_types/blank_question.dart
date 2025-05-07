import 'package:clean_architecture_template/features/tests/domain/entities/question.dart';
import 'package:flutter/material.dart';

class BlankQuestion extends StatefulWidget {
  final Question question;
  final String? answer;
  final Function(String) onAnswerChanged;

  const BlankQuestion({
    super.key,
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
  });

  @override
  State<BlankQuestion> createState() => _BlankQuestionState();
}

class _BlankQuestionState extends State<BlankQuestion> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.answer);
  }

  @override
  void didUpdateWidget(BlankQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.answer != oldWidget.answer && widget.answer != _controller.text) {
      _controller.text = widget.answer ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.prompt,
          style: const TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Введіть вашу відповідь...',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade700,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade700,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF7B61FF),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFF252538),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
          maxLines: null,
          onChanged: widget.onAnswerChanged,
        ),
      ],
    );
  }
} 