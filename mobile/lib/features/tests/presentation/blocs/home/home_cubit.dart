import 'package:bloc/bloc.dart';
import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/language.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/test.dart';
import 'package:clean_architecture_template/features/tests/domain/repositories/home_repository.dart';
import 'package:flutter/widgets.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.repository,
  }) : super(HomeInitial());

  final HomeRepository repository;

  void getData() async {
    emit(HomeLoading());

    final testsResult = await repository.getTests();
    final leaderBoardResult = await repository.getLeaderBoard();
    final languagesResult = await repository.getLanguages();

    testsResult.fold(
      (failure) => emit(HomeFailure(message: failure.errorMessage)),
      (tests) => leaderBoardResult.fold(
        (failure) {
          emit(HomeFailure(message: failure.errorMessage));
        },
        (leaderBoard) {
          languagesResult.fold(
            (failure) {
              emit(HomeFailure(message: failure.errorMessage));
            },
            (languages) {
              emit(HomeData(
                leaderBoard: leaderBoard, 
                tests: tests,
                languages: languages,
              ));
            },
          );
        }
      ),
    );
  }
  
  // Method to select a language filter
  void selectLanguage(int languageId) {
    if (state is HomeData) {
      final currentState = state as HomeData;
      
      // If the same language is selected again, clear the filter
      if (currentState.selectedLanguageId == languageId) {
        emit(currentState.copyWith(clearSelectedLanguage: true));
      } else {
        emit(currentState.copyWith(selectedLanguageId: languageId));
      }
    }
  }
  
  // Method to clear language filter
  void clearLanguageFilter() {
    if (state is HomeData) {
      final currentState = state as HomeData;
      emit(currentState.copyWith(clearSelectedLanguage: true));
    }
  }
}
