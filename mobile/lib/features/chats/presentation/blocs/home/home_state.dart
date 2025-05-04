part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeFailure extends HomeState {
  HomeFailure({required this.message});

  final String message;
}

class HomeData extends HomeState {
  HomeData({required this.leaderBoard, required this.tests});

  final List<User> leaderBoard;
  final List<Test> tests;
}

class HomeCreated extends HomeState {}

class HomeLoading extends HomeState {}
