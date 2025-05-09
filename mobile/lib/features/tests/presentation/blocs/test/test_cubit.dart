import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/answer.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/question.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/test_result.dart';
import 'package:clean_architecture_template/features/tests/domain/repositories/test_repository.dart';
import 'package:flutter/widgets.dart';

part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit({
    required this.repository,
  }) : super(TestInitial());

  final TestRepository repository;
  Timer? _timer;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  /// Loads questions for a specific test
  Future<void> loadTest(String testId) async {
    emit(TestLoading());

    final questionsResult = await repository.getTestQuestions(testId);

    questionsResult.fold(
      (failure) => emit(TestFailure(message: failure.errorMessage)),
      (questions) {
        emit(TestInProgress(
          testId: testId,
          questions: questions,
          startTime: DateTime.now(),
        ));
        
        // Start timer to update the state every second
        _startTimer();
      },
    );
  }
  
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state is TestInProgress) {
        final currentState = state as TestInProgress;
        // Force state update to refresh the timer display
        emit(currentState.copyWith());
      }
    });
  }

  /// Moves to the next question
  void nextQuestion() {
    if (state is TestInProgress) {
      final currentState = state as TestInProgress;
      
      if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
        emit(currentState.copyWith(
          currentQuestionIndex: currentState.currentQuestionIndex + 1,
        ));
      }
    }
  }

  /// Moves to the previous question
  void previousQuestion() {
    if (state is TestInProgress) {
      final currentState = state as TestInProgress;
      
      if (currentState.currentQuestionIndex > 0) {
        emit(currentState.copyWith(
          currentQuestionIndex: currentState.currentQuestionIndex - 1,
        ));
      }
    }
  }

  void answerQuestion(dynamic answer, {bool moveToNext = true}) {
    if (state is TestInProgress) {
      final currentState = state as TestInProgress;
      final currentQuestion = currentState.currentQuestion;
      
      final updatedAnswers = Map<int, dynamic>.from(currentState.userAnswers);
      updatedAnswers[currentQuestion.id] = answer;
      
      emit(currentState.copyWith(
        userAnswers: updatedAnswers,
      ));
      
      if (moveToNext && currentState.currentQuestionIndex < currentState.questions.length - 1) {
        nextQuestion();
      }
    }
  }

  void useHint() {
    if (state is TestInProgress) {
      final currentState = state as TestInProgress;
      
      emit(currentState.copyWith(
        usedHint: true,
      ));
    }
  }

  Future<void> submitTest() async {
    if (state is TestInProgress) {
      final currentState = state as TestInProgress;
      
      final answers = currentState.userAnswers.entries.map((entry) {
        final questionId = entry.key;
        final answerValue = entry.value;
        
        // Find the question with matching ID, with safer comparison
        Question? matchingQuestion;
        for (final q in currentState.questions) {
          if (q.id == questionId) {
            matchingQuestion = q;
            break;
          }
        }
        
        // Use the first question as fallback if no matching question found
        final question = matchingQuestion ?? currentState.questions.first;
        
        switch (question.type) {
          case 'single':
          case 'trace':
            return Answer.singleChoice(questionId, answerValue);
          case 'blank':
            return Answer.text(questionId, answerValue);
          case 'order':
            return Answer.ordering(questionId, List<int>.from(answerValue));
          case 'debug':
            return Answer.code(questionId, answerValue);
          default:
            return Answer(
              questionId: questionId,
              answer: {'value': answerValue},
            );
        }
      }).toList();
      
      emit(TestLoading());
      
      // Cancel the timer when submitting the test
      _timer?.cancel();
      
      final resultResponse = await repository.submitTest(
        currentState.testId,
        answers,
        timeSpent: currentState.timeSpentInSeconds,
        usedHint: currentState.usedHint,
      );
      
      resultResponse.fold(
        (failure) => emit(TestFailure(message: failure.errorMessage)),
        (result) => emit(TestCompleted(
          result: result,
          questions: currentState.questions,
          userAnswers: currentState.userAnswers,
          testId: currentState.testId,
        )),
      );
    }
  }
  
  /// Restarts the current test
  void restartTest() {
    if (state is TestInProgress) {
      final currentState = state as TestInProgress;
      
      // Cancel existing timer
      _timer?.cancel();
      
      emit(TestInProgress(
        testId: currentState.testId,
        questions: currentState.questions,
        startTime: DateTime.now(),
      ));
      
      // Start a new timer
      _startTimer();
    } else if (state is TestCompleted) {
      final completedState = state as TestCompleted;
      
      // Use the stored testId
      loadTest(completedState.testId);
    }
  }

  /// Jumps to a specific question by index
  void jumpToQuestion(int index) {
    if (state is TestInProgress) {
      final currentState = state as TestInProgress;
      
      if (index >= 0 && index < currentState.questions.length) {
        emit(currentState.copyWith(
          currentQuestionIndex: index,
        ));
      }
    }
  }
}
