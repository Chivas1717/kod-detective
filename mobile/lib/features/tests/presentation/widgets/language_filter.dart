import 'package:clean_architecture_template/features/tests/domain/entities/language.dart';
import 'package:flutter/material.dart';

class LanguageFilter extends StatelessWidget {
  final List<Language> languages;
  final int? selectedLanguageId;
  final Function(int) onLanguageSelected;
  final VoidCallback onClearFilter;

  const LanguageFilter({
    super.key,
    required this.languages,
    this.selectedLanguageId,
    required this.onLanguageSelected,
    required this.onClearFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Filter by Language",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: languages.length + 1, // +1 for "All" option
            itemBuilder: (context, index) {
              // First item is "All"
              if (index == 0) {
                return _buildLanguageChip(
                  null,
                  "All",
                  selectedLanguageId == null,
                );
              }
              
              final language = languages[index - 1];
              return _buildLanguageChip(
                language.id,
                language.name,
                selectedLanguageId == language.id,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageChip(
    int? languageId,
    String name,
    bool isSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        backgroundColor: const Color(0xFF252538),
        selectedColor: const Color(0xFF7B61FF),
        onSelected: (selected) {
          if (languageId == null) {
            onClearFilter();
          } else {
            onLanguageSelected(languageId);
          }
        },
      ),
    );
  }
} 