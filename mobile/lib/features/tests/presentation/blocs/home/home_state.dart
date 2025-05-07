part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeFailure extends HomeState {
  HomeFailure({required this.message});

  final String message;
}

class HomeData extends HomeState {
  HomeData({
    required this.leaderBoard, 
    required this.tests,
    required this.languages,
    this.selectedLanguageId,
  });

  final List<User> leaderBoard;
  final List<Test> tests;
  final List<Language> languages;
  final int? selectedLanguageId;
  
  // Get filtered tests based on selected language
  List<Test> get filteredTests {
    if (selectedLanguageId == null) {
      return tests;
    }
    return tests.where((test) => test.language == selectedLanguageId).toList();
  }
  
  // Create a copy with updated fields
  HomeData copyWith({
    List<User>? leaderBoard,
    List<Test>? tests,
    List<Language>? languages,
    int? selectedLanguageId,
    bool clearSelectedLanguage = false,
  }) {
    return HomeData(
      leaderBoard: leaderBoard ?? this.leaderBoard,
      tests: tests ?? this.tests,
      languages: languages ?? this.languages,
      selectedLanguageId: clearSelectedLanguage ? null : (selectedLanguageId ?? this.selectedLanguageId),
    );
  }
}

class HomeCreated extends HomeState {}

class HomeLoading extends HomeState {}
