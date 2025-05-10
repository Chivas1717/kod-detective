import 'package:clean_architecture_template/features/tests/domain/entities/question.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/test_result.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/custom_test_button.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:clean_architecture_template/features/tests/presentation/blocs/home/home_cubit.dart';

class TestCompletionCard extends StatefulWidget {
  final TestResult result;
  final List<Question> questions;
  final Map<int, dynamic> userAnswers;
  final VoidCallback onRetry;
  final VoidCallback onBackToTests;
  final HomeCubit? homeCubit;

  const TestCompletionCard({
    super.key,
    required this.result,
    required this.questions,
    required this.userAnswers,
    required this.onRetry,
    required this.onBackToTests,
    this.homeCubit,
  });

  @override
  State<TestCompletionCard> createState() => _TestCompletionCardState();
}

class _TestCompletionCardState extends State<TestCompletionCard> {
  bool _showWrongAnswers = false;

  @override
  Widget build(BuildContext context) {
    final percentage = widget.result.totalQuestions > 0
        ? widget.result.correctAnswers / widget.result.totalQuestions
        : 0.0;
    
    final isPassed = widget.result.isPassed;
    
    return Container(
      color: const Color(0xFF1E1E2E),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: const Color(0xFF252538),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isPassed ? 'Вітаємо!' : 'Непогано! Продовжуй вчитися!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isPassed ? Colors.green : Colors.yellow,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.result.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      CircularPercentIndicator(
                        radius: 80,
                        lineWidth: 12,
                        percent: percentage,
                        center: Text(
                          '${(percentage * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        progressColor: _getColorForPercentage(percentage),
                        backgroundColor: Colors.grey.shade800,
                        circularStrokeCap: CircularStrokeCap.round,
                        animation: true,
                        animationDuration: 1000,
                      ),
                      const SizedBox(height: 32),
                      _buildResultRow(
                        'Правильні відповіді:',
                        '${widget.result.correctAnswers}/${widget.result.totalQuestions}',
                      ),
                      const SizedBox(height: 8),
                      _buildResultRow(
                        'Отримані бали:',
                        '${widget.result.scoreObtained}',
                      ),const SizedBox(height: 8),
                      _buildResultRow(
                        'Загальна кількість балів:',
                        '${widget.result.totalScore}',
                      ),
                      const SizedBox(height: 24),
                      Column(
                        children: [
                          CustomTestButton(
                            text: 'До списку тестів',
                            onPressed: () {
                              if (widget.homeCubit != null) {
                                widget.homeCubit!.getData();
                              }
                              widget.onBackToTests();
                            },
                            icon: Icons.list,
                          ),
                          const SizedBox(height: 12),
                          CustomTestButton(
                            text: 'Спробувати знову',
                            isPrimary: true,
                            onPressed: widget.onRetry,
                            icon: Icons.refresh,
                          ),
                          if (widget.result.correctAnswers < widget.result.totalQuestions) ...[
                            const SizedBox(height: 12),
                            CustomTestButton(
                              text: _showWrongAnswers 
                                  ? 'Сховати неправильні відповіді' 
                                  : 'Показати неправильні відповіді',
                              onPressed: () {
                                setState(() {
                                  _showWrongAnswers = !_showWrongAnswers;
                                });
                              },
                              icon: _showWrongAnswers ? Icons.visibility_off : Icons.visibility,
                              backgroundColor: const Color(0xFF3A3A4E),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_showWrongAnswers) ...[
                const SizedBox(height: 24),
                _buildWrongAnswersSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWrongAnswersSection() {
    // Find questions with wrong answers
    final wrongAnswers = <int>[];
    
    for (final question in widget.questions) {
      final userAnswer = widget.userAnswers[question.id];
      bool isCorrect = false;
      
      if (userAnswer != null) {
        switch (question.type) {
          case 'single':
          case 'trace':
            isCorrect = userAnswer == question.correctAnswer['id'];
            break;
          case 'blank':
            isCorrect = userAnswer.toLowerCase() == 
                question.correctAnswer['text'].toLowerCase();
            break;
          case 'order':
            final correctOrder = List<int>.from(question.correctAnswer['order']);
            isCorrect = userAnswer.toString() == correctOrder.toString();
            break;
          case 'debug':
            // Simplified check - in reality might need more complex comparison
            isCorrect = userAnswer == question.correctAnswer['correctedCode'];
            break;
        }
      }
      
      if (!isCorrect) {
        wrongAnswers.add(question.id);
      }
    }
    
    if (wrongAnswers.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Неправильні відповіді:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...widget.questions
            .where((q) => wrongAnswers.contains(q.id))
            .map((question) => _buildWrongAnswerItem(question))
            .toList(),
      ],
    );
  }

  Widget _buildWrongAnswerItem(Question question) {
    final userAnswer = widget.userAnswers[question.id];
    String userAnswerText = 'Не відповіли';
    String correctAnswerText = '';
    
    switch (question.type) {
      case 'single':
      case 'trace':
        if (userAnswer != null) {
          final options = List<Map<String, dynamic>>.from(
              question.metadata['options'] ?? []);
          final userOption = options.firstWhere(
            (o) => o['id'] == userAnswer,
            orElse: () => {'text': 'Невідомий варіант'},
          );
          userAnswerText = userOption['text'];
        }
        
        final correctId = question.correctAnswer['id'];
        final options = List<Map<String, dynamic>>.from(
            question.metadata['options'] ?? []);
        final correctOption = options.firstWhere(
          (o) => o['id'] == correctId,
          orElse: () => {'text': 'Невідомий варіант'},
        );
        correctAnswerText = correctOption['text'];
        break;
        
      case 'blank':
        userAnswerText = userAnswer ?? 'Не відповіли';
        correctAnswerText = question.correctAnswer['text'];
        break;
        
      case 'order':
        if (userAnswer != null) {
          final options = List<Map<String, dynamic>>.from(
              question.metadata['options'] ?? []);
          final userOrder = List<int>.from(userAnswer);
          userAnswerText = userOrder
              .map((id) => options
                  .firstWhere((o) => o['id'] == id, orElse: () => {'text': '?'})['text'])
              .join(' → ');
        }
        
        final correctOrder = List<int>.from(question.correctAnswer['order']);
        final options = List<Map<String, dynamic>>.from(
            question.metadata['options'] ?? []);
        correctAnswerText = correctOrder
            .map((id) => options
                .firstWhere((o) => o['id'] == id, orElse: () => {'text': '?'})['text'])
            .join(' → ');
        break;
        
      case 'debug':
        userAnswerText = userAnswer ?? 'Не відповіли';
        correctAnswerText = question.correctAnswer['correctedCode'];
        break;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF2A2A3C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.prompt,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _buildAnswerRow('Ваша відповідь:', userAnswerText, false),
            const SizedBox(height: 8),
            _buildAnswerRow('Правильна відповідь:', correctAnswerText, true),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerRow(String label, String value, bool isCorrect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCorrect 
                ? Colors.green.withOpacity(0.2) 
                : Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: isCorrect ? Colors.green.shade300 : Colors.red.shade300,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade300,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Color _getColorForPercentage(double percentage) {
    if (percentage >= 0.8) {
      return Colors.green;
    } else if (percentage >= 0.6) {
      return const Color.fromARGB(255, 188, 240, 129);
    } else if (percentage >= 0.4) {
      return Colors.yellow;
    } else if (percentage >= 0.2) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
} 