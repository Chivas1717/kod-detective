import 'package:bloc/bloc.dart';
import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_template/features/auth/presentation/blocs/user_cubit/user_cubit.dart';
import 'package:clean_architecture_template/features/tests/domain/entities/completed_test.dart';
import 'package:clean_architecture_template/features/tests/domain/repositories/home_repository.dart';
import 'package:clean_architecture_template/features/tests/presentation/blocs/home/home_cubit.dart';
import 'package:flutter/widgets.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.repository,
    required this.userCubit,
    required this.homeCubit,
  }) : super(ProfileInitial());

  final HomeRepository repository;
  final UserCubit userCubit;
  final HomeCubit homeCubit;

  // Get current user's profile data
  Future<void> getCurrentUserProfile() async {
    emit(ProfileLoading());

    final completedTestsResult = await repository.getCompletedTests();

    completedTestsResult.fold(
      (failure) => emit(ProfileFailure(message: failure.errorMessage)),
      (completedTests) {
        emit(ProfileData(
          completedTests: completedTests,
        ));
      },
    );
  }

  // Get another user's profile data
  Future<void> getUserProfile(int userId) async {
    emit(ProfileLoading());

    final userResult = await repository.getUserProfile(userId);
    
    userResult.fold(
      (failure) => emit(ProfileFailure(message: failure.errorMessage)),
      (user) async {
        final completedTestsResult = await repository.getUserCompletedTests(userId);
        
        completedTestsResult.fold(
          (failure) => emit(ProfileFailure(message: failure.errorMessage)),
          (completedTests) {
            emit(ProfileData(
              user: user,
              completedTests: completedTests,
            ));
          },
        );
      },
    );
  }
  
  // Update user profile
  Future<void> updateUsername(String username) async {
    emit(ProfileUpdating());
    
    // Use the UserCubit to update the username
    final result = await userCubit.updateUsername(username);
    
    if (result) {
      // Refresh profile data after successful update
      getCurrentUserProfile();
      
      // Refresh home data to update leaderboard
      homeCubit.getData();
    } else {
      emit(ProfileFailure(message: 'Failed to update username'));
    }
  }
} 