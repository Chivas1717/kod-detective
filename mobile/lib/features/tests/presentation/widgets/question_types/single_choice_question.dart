import 'package:clean_architecture_template/features/tests/domain/entities/question.dart';
import 'package:flutter/material.dart';

class SingleChoiceQuestion extends StatelessWidget {
  final Question question;
  final String? selectedOptionId;
  final Function(String) onOptionSelected;

  const SingleChoiceQuestion({
    super.key,
    required this.question,
    required this.selectedOptionId,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final options = List<Map<String, dynamic>>.from(question.metadata['options'] ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.prompt,
          style: const TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...options.map((option) {
          final optionId = option['id'];
          final optionText = option['text'];
          final isSelected = selectedOptionId == optionId;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: isSelected 
                  ? const Color(0xFF7B61FF).withOpacity(0.3)
                  : const Color(0xFF252538),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => onOptionSelected(optionId),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected 
                                ? const Color(0xFF7B61FF)
                                : Colors.grey.shade600,
                            width: 2,
                          ),
                          color: isSelected 
                              ? const Color(0xFF7B61FF)
                              : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          optionText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
} 