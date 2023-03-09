import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/error/exceptions.dart';

class AuthRemoteData {
  UserCredential? userCredential;
  late String phone;
  late String userId;

  //

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      userCredential = credential;
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
        throw WrongPasswordException();
      } else if (e.code == 'invalid-email') {
        debugPrint('the email address is not valid');
        throw InvalidEmailException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      debugPrint(
          'signInWithEmailAndPassword :: Auth remote repo :: Exception :: $e');
      throw ServerException();
    }
  }
}
