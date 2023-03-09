import 'package:dartz/dartz.dart';
import 'package:quiz_admin/features/create_quiz/services/create_quiz_local_data.dart';
import 'package:quiz_admin/features/create_quiz/services/create_quiz_remote_data.dart';
import 'package:quiz_admin/features/home_screen/services/models/quiz_model.dart';

import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';

class CreateQuizRepo {
  final CreateQuizRemoteData createQuizRemoteData;
  final CreateQuizLocalData createQuizLocalData;
  final NetworkInfo networkInfo;
  CreateQuizRepo({
    required this.createQuizRemoteData,
    required this.createQuizLocalData,
    required this.networkInfo,
  });

  Future<Either<Failure, Unit>> createQuiz(QuizModel quiz) async {
    if (await networkInfo.isConnected) {
      try {
        await createQuizRemoteData.createQuiz(quiz);
        return Future.value(const Right(unit));
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  //
  Future<Either<Failure, Unit>> editQuiz(QuizModel quiz) async {
    if (await networkInfo.isConnected) {
      try {
        await createQuizRemoteData.editQuiz(quiz);
        return Future.value(const Right(unit));
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
