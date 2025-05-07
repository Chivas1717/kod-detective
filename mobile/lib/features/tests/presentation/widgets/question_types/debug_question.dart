import 'package:clean_architecture_template/features/tests/domain/entities/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/javascript.dart';

class DebugQuestion extends StatefulWidget {
  final Question question;
  final String? correctedCode;
  final Function(String) onCodeChanged;

  const DebugQuestion({
    super.key,
    required this.question,
    required this.correctedCode,
    required this.onCodeChanged,
  });

  @override
  State<DebugQuestion> createState() => _DebugQuestionState();
}

class _DebugQuestionState extends State<DebugQuestion> {
  late CodeController _codeController;

  @override
  void initState() {
    super.initState();
    final initialCode = widget.correctedCode ?? widget.question.metadata['originalCode'] ?? '';
    _codeController = CodeController(
      text: initialCode,
      language: javascript,
    );
    
    // Listen for changes and notify parent
    _codeController.addListener(() {
      widget.onCodeChanged(_codeController.text);
    });
  }

  @override
  void didUpdateWidget(DebugQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.correctedCode != oldWidget.correctedCode && 
        widget.correctedCode != _codeController.text) {
      _codeController.text = widget.correctedCode ?? 
                            widget.question.metadata['originalCode'] ?? '';
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.prompt.split('\n\n').first, // Only show the instruction part
          style: const TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Виправте код нижче:',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade300,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade800,
            ),
          ),
          height: 300, // Fixed height for the editor
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CodeTheme(
              data: CodeThemeData(styles: monokaiSublimeTheme),
              child: CodeField(
                controller: _codeController,
                textStyle: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 