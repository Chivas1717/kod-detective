import 'package:clean_architecture_template/core/helper/images.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/question.dart';
import 'package:clean_architecture_template/features/tests/presentation/blocs/test/test_cubit.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/custom_test_button.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/question_types/blank_question.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/question_types/debug_question.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/question_types/order_question.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/question_types/single_choice_question.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/test_completion_card.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/test_progress_bar.dart';
import 'package:clean_architecture_template/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({
    super.key,
    required this.testId,
  });

  final String testId;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late TestCubit testCubit;
  bool isClueVisible = false;
  bool isHintVisible = false;

  @override
  void initState() {
    super.initState();
    testCubit = sl<TestCubit>()..loadTest(widget.testId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF252538),
        elevation: 4,
        title: const Text(
          'Тест',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          BlocBuilder<TestCubit, TestState>(
            bloc: testCubit,
            builder: (context, state) {
              if (state is TestInProgress) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B61FF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatTime(state.timeSpentInSeconds),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<TestCubit, TestState>(
        bloc: testCubit,
        builder: (context, state) {
          if (state is TestLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7B61FF),
              ),
            );
          } else if (state is TestFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Помилка: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  CustomTestButton(
                    text: 'Спробувати знову',
                    isPrimary: true,
                    onPressed: () => testCubit.loadTest(widget.testId),
                    icon: Icons.refresh,
                  ),
                ],
              ),
            );
          } else if (state is TestInProgress) {
            return Stack(
              children: [
                Column(
                  children: [
                    TestProgressBar(
                      currentIndex: state.currentQuestionIndex,
                      questions: state.questions,
                      answeredQuestionIds: state.userAnswers.keys.toList(),
                      onQuestionSelected: (index) {
                        testCubit.jumpToQuestion(index);
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF252538),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7B61FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${state.currentQuestionIndex + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Питання ${state.currentQuestionIndex + 1} з ${state.questions.length}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildQuestionWidget(state.currentQuestion, state.userAnswers),
                            const SizedBox(height: 32),
                            _buildNavigationButtons(state),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (isClueVisible)
                  _buildOverlay(
                    state.currentQuestion.clue ?? 'Підказка недоступна',
                    const Color(0xFF3A3A4E),
                    () => setState(() => isClueVisible = false),
                    false,
                  ),
                if (isHintVisible)
                  _buildOverlay(
                    state.currentQuestion.hint ?? 'Підказка недоступна',
                    const Color(0xFF2A2A3C),
                    () => setState(() => isHintVisible = false),
                    true,
                  ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Column(
                    children: [
                      if (state.currentQuestion.hint != null)
                        FloatingActionButton(
                          heroTag: 'hint',
                          mini: true,
                          backgroundColor: const Color(0xFF7B61FF),
                          onPressed: () {
                            setState(() {
                              isHintVisible = true;
                              isClueVisible = false;
                            });
                            testCubit.useHint();
                          },
                          child: const Icon(Icons.lightbulb, color: Colors.amber),
                        ),
                      const SizedBox(height: 8),
                      if (state.currentQuestion.clue != null)
                        FloatingActionButton(
                          heroTag: 'clue',
                          mini: true,
                          backgroundColor: const Color(0xFF3A3A4E), // Changed to a dark background color
                          onPressed: () {
                            setState(() {
                              isClueVisible = true;
                              isHintVisible = false;
                            });
                            testCubit.useHint();
                          },
                          child: SvgPicture.asset(
                            SvgIcons.detective,
                            width: 24,
                            height: 24,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is TestCompleted) {
            return TestCompletionCard(
              result: state.result,
              onRetry: () => testCubit.restartTest(),
              onBackToTests: () => Navigator.of(context).pop(),
              questions: state.questions,
              userAnswers: state.userAnswers,
            );
          }
          
          return const Center(
            child: Text(
              'Завантаження тесту...',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionWidget(Question question, Map<int, dynamic> userAnswers) {
    final dynamic currentAnswer = userAnswers[question.id];
    
    switch (question.type) {
      case 'single':
      case 'trace':
        return SingleChoiceQuestion(
          question: question,
          selectedOptionId: currentAnswer,
          onOptionSelected: (optionId) {
            // Only store the answer, don't move to next question automatically
            testCubit.answerQuestion(optionId, moveToNext: false);
          },
        );
      case 'blank':
        return BlankQuestion(
          question: question,
          answer: currentAnswer,
          onAnswerChanged: (text) => testCubit.answerQuestion(text, moveToNext: false),
        );
      case 'order':
        return OrderQuestion(
          question: question,
          currentOrder: currentAnswer != null ? List<int>.from(currentAnswer) : null,
          onOrderChanged: (order) => testCubit.answerQuestion(order, moveToNext: false),
        );
      case 'debug':
        return DebugQuestion(
          question: question,
          correctedCode: currentAnswer,
          onCodeChanged: (code) => testCubit.answerQuestion(code, moveToNext: false),
        );
      default:
        return Text(
          'Непідтримуваний тип питання: ${question.type}',
          style: const TextStyle(color: Colors.white),
        );
    }
  }

  Widget _buildNavigationButtons(TestInProgress state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTestButton(
          text: 'Назад',
          onPressed: state.currentQuestionIndex > 0
              ? () => testCubit.previousQuestion()
              : null,
          icon: Icons.arrow_back,
        ),
        if (state.isComplete)
          CustomTestButton(
            text: 'Завершити тест',
            isPrimary: true,
            onPressed: () => testCubit.submitTest(),
            backgroundColor: Colors.green,
            icon: Icons.check_circle,
          )
        else
          CustomTestButton(
            text: 'Далі',
            isPrimary: true,
            onPressed: state.currentQuestionIndex < state.questions.length - 1
                ? () => testCubit.nextQuestion()
                : null,
            icon: Icons.arrow_forward,
          ),
      ],
    );
  }

  Widget _buildOverlay(String content, Color backgroundColor, VoidCallback onClose, bool isHint) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping on the card
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with icon
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: backgroundColor.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: isHint 
                          ? const Icon(
                              Icons.lightbulb,
                              color: Colors.amber,
                              size: 48,
                            )
                          : SvgPicture.asset(
                              SvgIcons.detective,
                              width: 100,
                              height: 100,
                            ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      content,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Close button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CustomTestButton(
                      text: 'Зрозуміло',
                      isPrimary: true,
                      onPressed: onClose,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
