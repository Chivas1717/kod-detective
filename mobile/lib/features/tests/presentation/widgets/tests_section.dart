import 'package:clean_architecture_template/core/widgets/transitions/transitions.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/test.dart';
import 'package:clean_architecture_template/features/tests/presentation/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TestsSection extends StatelessWidget {
  final List<Test> tests;

  const TestsSection({
    super.key,
    required this.tests,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Доступні тести",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (tests.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.search_off,
                    color: Colors.white54,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Немає доступних тестів для цієї мови програмування",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 220,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: tests.length,
              itemBuilder: (context, index) {
                final test = tests[index];
                return TestCard(
                  test: test,
                  index: index,
                )
                    .animate()
                    .fadeIn(
                      delay: Duration(milliseconds: 100 * index),
                      duration: const Duration(milliseconds: 600),
                    )
                    .slideX(
                      delay: Duration(milliseconds: 100 * index),
                      begin: 0.2,
                      end: 0,
                      duration: const Duration(milliseconds: 500),
                    );
              },
            ),
          ),
      ],
    );
  }
}

class TestCard extends StatelessWidget {
  final Test test;
  final int index;

  const TestCard({
    super.key,
    required this.test,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      constraints: const BoxConstraints(maxHeight: 260),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColors(test.difficulty ?? 'medium'),
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getPrimaryColor(test.difficulty ?? 'medium').withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              FadePageTransition(child: TestScreen(testId: test.id.toString())),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _getLanguageIcon(test.languageCode ?? 'js'),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getDifficultyText(test.difficulty ?? 'medium'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  test.title ?? 'Unnamed Test',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  test.languageName ?? 'Unknown Language',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Розпочати",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return [
          const Color(0xFF4CAF50),
          const Color(0xFF2E7D32),
        ];
      case 'medium':
        return [
          const Color(0xFF2196F3),
          const Color(0xFF0D47A1),
        ];
      case 'hard':
        return [
          const Color(0xFFF44336),
          const Color(0xFFB71C1C),
        ];
      default:
        return [
          const Color(0xFF7B61FF),
          const Color(0xFF5C4BC3),
        ];
    }
  }

  Color _getPrimaryColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF4CAF50);
      case 'medium':
        return const Color(0xFF2196F3);
      case 'hard':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF7B61FF);
    }
  }

  String _getDifficultyText(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 'Easy';
      case 'medium':
        return 'Medium';
      case 'hard':
        return 'Hard';
      default:
        return 'Unknown';
    }
  }

  Widget _getLanguageIcon(String languageCode) {
    IconData iconData;

    switch (languageCode.toLowerCase()) {
      case 'js':
        iconData = Icons.javascript;
        break;
      case 'py':
        iconData = Icons.code;
        break;
      case 'java':
        iconData = Icons.coffee;
        break;
      case 'cpp':
        iconData = Icons.code;
        break;
      default:
        iconData = Icons.code;
    }

    return Icon(
      iconData,
      color: Colors.white,
      size: 24,
    );
  }
}
