part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdating extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure({required this.message});
}

class ProfileData extends ProfileState {
  final User? user;
  final List<CompletedTest> completedTests;

  ProfileData({
    this.user,
    required this.completedTests,
  });
} 