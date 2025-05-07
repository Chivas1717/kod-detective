import 'package:bloc/bloc.dart';
import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
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

    testsResult.fold(
      (failure) => emit(HomeFailure(message: failure.errorMessage)),
      (tests) => leaderBoardResult.fold(
        (failure) {
          emit(HomeFailure(message: failure.errorMessage));
        },
        (leaderBoard) {
          emit(HomeData(leaderBoard: leaderBoard, tests: tests));
        }
      ),
    );
  }
}
