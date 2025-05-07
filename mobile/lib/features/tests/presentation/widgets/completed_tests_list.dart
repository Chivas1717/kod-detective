import 'package:clean_architecture_template/features/tests/domain/entities/completed_test.dart';
import 'package:flutter/material.dart';

class CompletedTestsList extends StatelessWidget {
  final List<CompletedTest> completedTests;

  const CompletedTestsList({
    super.key,
    required this.completedTests,
  });

  @override
  Widget build(BuildContext context) {
    if (completedTests.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: completedTests.length,
      itemBuilder: (context, index) {
        final test = completedTests[index];
        return _buildCompletedTestCard(test);
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.assignment_outlined,
            color: Colors.white54,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            "Немає завершених тестів",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedTestCard(CompletedTest test) {
    // Determine difficulty color
    Color difficultyColor;
    switch (test.testDifficulty.toLowerCase()) {
      case 'easy':
        difficultyColor = const Color(0xFF4CAF50);
        break;
      case 'medium':
        difficultyColor = const Color(0xFFFFA726);
        break;
      case 'hard':
        difficultyColor = const Color(0xFFF44336);
        break;
      default:
        difficultyColor = const Color(0xFF7B61FF);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFF252538),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Language indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B61FF).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    test.languageName,
                    style: const TextStyle(
                      color: Color(0xFF7B61FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Difficulty indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: difficultyColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getDifficultyText(test.testDifficulty),
                    style: TextStyle(
                      color: difficultyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                // Completion date
                Text(
                  test.formattedDate,
                  style: const TextStyle(
                    color: Color(0xFFADB5BD),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Test title
            Text(
              test.testTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Score
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.star,
                  color: Color(0xFFFFD700),
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  'Бали: ${test.scoreObtained}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getDifficultyText(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 'Легкий';
      case 'medium':
        return 'Середній';
      case 'hard':
        return 'Складний';
      default:
        return difficulty;
    }
  }
} 