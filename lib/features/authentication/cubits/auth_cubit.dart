import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_admin/core/extensions/string_extension.dart';

import '../../../../core/error/failures.dart';
import '../../../resources/app_strings.dart';
import '../../general/services/general_repo.dart';
import '../services/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  final GeneralRepo generalRepo;

  AuthCubit({
    required this.authRepo,
    required this.generalRepo,
  }) : super(AuthInitial());

  static AuthCubit getIns(context) {
    return BlocProvider.of<AuthCubit>(context);
  }

  validateName(BuildContext context, String value) {
    if (value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    } else {
      return null;
    }
  }

  validateEmail(BuildContext context, String value) {
    if (value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    }
    final isValid = EmailValidator.validate(value);
    if (isValid) {
      return null;
    }
    return AppStrings.invalidEmail.tr(context);
  }

  validatePassword(BuildContext context, String value) {
    if (value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    }
    if (value.length < 5) {
      return AppStrings.passwordMustBe.tr(context);
    }
    return null;
  }

  validateSecondPassword(BuildContext context, String value, String firstPass) {
    if (value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    }
    if (value != firstPass) {
      return AppStrings.twoPasswordsNotIdentical.tr(context);
    }
    return null;
  }

  Future login(
      String email, String password, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      //
      emit(AuthStartLoadingState());
      final either = await authRepo.signInWithEmailAndPassword(email, password);
      either.fold(
        (failure) {
          _handleFailure(failure);
        },
        (credential) async {
          //
          final String id = credential.user!.uid;
          await generalRepo.setString(AppStrings.storedId, id);
          //
          final temp1 = await _saveToken(credential);
          if (temp1) {
            emit(AuthEndLoadingToHomeScreen());
          } else {
            emit(AuthEndLoadingStateWithError(AppStrings.someThingWentWrong));
          }
        },
      );
    }
  }


  _handleFailure(Failure failure) {
    if (failure.runtimeType == OfflineFailure) {
      emit(AuthEndLoadingStateWithError(AppStrings.internetConnectionError));
    } else if (failure.runtimeType == ServerFailure) {
      emit(AuthEndLoadingStateWithError(AppStrings.someThingWentWrong));
    } else if (failure.runtimeType == WeakPasswordFailure) {
      emit(AuthEndLoadingStateWithError(AppStrings.weakPassword));
    } else if (failure.runtimeType == EmailInUseFailure) {
      emit(AuthEndLoadingStateWithError(AppStrings.emailInUse));
    } else if (failure.runtimeType == UserNotFoundFailure) {
      emit(AuthEndLoadingStateWithError(AppStrings.userNotFound));
    } else if (failure.runtimeType == WrongPasswordFailure) {
      emit(AuthEndLoadingStateWithError(AppStrings.wrongPassword));
    } else if (failure.runtimeType == CacheSavingFailure) {
      emit(AuthEndLoadingStateWithError(AppStrings.savingTokenError));
    } else if (failure.runtimeType == InvalidEmailFailure) {
      emit(AuthEndLoadingStateWithError(AppStrings.invalidEmail));
    }
  }

  Future<bool> _saveToken(UserCredential credential) async {
    final token = await credential.user?.getIdToken();
    if (token != null) {
      final either = await generalRepo.setString(AppStrings.storedToken, token);
      return either.fold((failure) {
        _handleFailure(failure);
        return false;
      }, (success) {
        return true;
      });
    } else {
      debugPrint('The token is nullllllllllll!');
      return false;
    }
  }
}
