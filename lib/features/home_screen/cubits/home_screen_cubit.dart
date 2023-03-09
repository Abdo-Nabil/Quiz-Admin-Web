import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_admin/core/extensions/string_extension.dart';
import 'package:quiz_admin/features/home_screen/services/models/quiz_model.dart';

import '../../../core/error/failures.dart';
import '../../../resources/app_strings.dart';
import '../../authentication/services/auth_repo.dart';
import '../../general/services/general_repo.dart';
import '../services/home_repo.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final HomeRepo homeRepo;
  final AuthRepo authRepo;
  final GeneralRepo generalRepo;

  HomeScreenCubit(this.homeRepo, this.authRepo, this.generalRepo)
      : super(HomeScreenInitial());

  emitInitialState() {
    emit(HomeScreenInitial());
  }

  static HomeScreenCubit getIns(BuildContext context) {
    return BlocProvider.of<HomeScreenCubit>(context);
  }

  Future getData() async {
    emit(HomeLoadingState());
    final either = await homeRepo.getQuizzes();
    either.fold(
      (l) {
        _handleFailure(l);
      },
      (r) {
        emit(HomeScreenGetData(quizzes: r));
      },
    );
  }

  String? validateField(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    } else {
      return null;
    }
  }

  deleteQuiz(String quizId) async {
    final either = await homeRepo.deleteQuiz(quizId);
    either.fold(
      (l) {
        _handleFailure(l);
      },
      (r) {
        getData();
      },
    );
  }

  _handleFailure(Failure failure) {
    if (failure.runtimeType == OfflineFailure) {
      emit(const HomeEndLoadingWithFailureState(
          text: AppStrings.internetConnectionError));
    } else if (failure.runtimeType == ServerFailure) {
      emit(const HomeEndLoadingWithFailureState(
          text: AppStrings.someThingWentWrong));
    } else if (failure.runtimeType == CacheSavingFailure) {
      emit(const HomeEndLoadingWithFailureState(
          text: AppStrings.savingTokenError));
    } else if (failure.runtimeType == CacheRemovingFailure) {
      emit(const HomeEndLoadingWithFailureState(
          text: AppStrings.removingTokenError));
    }
  }
}
