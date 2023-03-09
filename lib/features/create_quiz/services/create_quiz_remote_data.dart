import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_admin/features/home_screen/services/models/quiz_model.dart';

import '../../../core/error/exceptions.dart';

class CreateQuizRemoteData {
  final http.Client client;
  CreateQuizRemoteData({required this.client});

  Future createQuiz(QuizModel quiz) async {
    //
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("quizzes").doc(quiz.quizId).set(quiz.toJson());
    } catch (e) {
      debugPrint("CreateQuizRemoteData :: createQuiz :: Exception :: $e");
      throw ServerException();
    }
  }

  //
  Future editQuiz(QuizModel quiz) async {
    //
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("quizzes").doc(quiz.quizId).set(quiz.toJson());
    } catch (e) {
      debugPrint("CreateQuizRemoteData :: editQuiz :: Exception :: $e");
      throw ServerException();
    }
  }
}
