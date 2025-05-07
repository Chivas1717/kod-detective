import 'package:clean_architecture_template/features/tests/domain/entities/test.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class TestState {}

class TestInitial extends TestState {}

class TestFailure extends TestState {
  TestFailure({required this.message});

  final String message;
}

class TestData extends TestState {
  TestData({required this.test});

  final Test test;
}

class TestCreated extends TestState {}

class TestLoading extends TestState {}
