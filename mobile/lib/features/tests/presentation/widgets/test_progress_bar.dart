import 'package:flutter/material.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/question.dart';

class TestProgressBar extends StatelessWidget {
  final int currentIndex;
  final List<Question> questions;
  final List<int> answeredQuestionIds;
  final Function(int) onQuestionSelected;

  const TestProgressBar({
    super.key,
    required this.currentIndex,
    required this.questions,
    required this.answeredQuestionIds,
    required this.onQuestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF252538),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(questions.length, (index) {
          final questionId = questions[index].id;
          final isAnswered = answeredQuestionIds.contains(questionId);
          final isCurrent = index == currentIndex;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => onQuestionSelected(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isAnswered
                      ? const Color(0xFF4CAF50)
                      : isCurrent
                          ? const Color(0xFF7B61FF)
                          : const Color(0xFF3A3A4E),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: isCurrent ? [
                    BoxShadow(
                      color: const Color(0xFF7B61FF).withOpacity(0.4),
                      blurRadius: 4,
                      spreadRadius: 1,
                    )
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
} 