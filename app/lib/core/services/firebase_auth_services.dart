import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stylebox/core/errors/exception.dart';
import 'package:stylebox/core/utils/hash_helper.dart';

class FirebaseAuthServices {
  Future deleteUser() async {
    FirebaseAuth.instance.currentUser!.delete();
  }

  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final hashedPassword = HashHelper.passwordHash(password);
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: hashedPassword,
          );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        "Error in FirebaseAuthServices.createUserWithEmailAndPassword: $e code: ${e.code}",
      );
      if (e.code == 'weak-password') {
        throw CustomException(message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException(
          message: 'The email address is already in use by another account.',
        );
      } else if (e.code == 'network-request-failed') {
        throw CustomException(
          message:
              'Network request failed, please check your internet connection.',
        );
      } else if (e.code == 'invalid-email') {
        throw CustomException(message: 'The email address is not valid.');
      } else {
        throw CustomException(
          message: 'An unknown error occurred please try again later.',
        );
      }
    } catch (e) {
      log("Error in FirebaseAuthServices.createUserWithEmailAndPassword: $e");
      throw CustomException(
        message: 'An unknown error occurred please try again later.',
      );
    }
  }

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final hashedPassword = HashHelper.passwordHash(password);

      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: hashedPassword);
        return credential.user!;
      } on FirebaseAuthException catch (e) {
        if (e.code != 'user-not-found' && e.code != 'wrong-password') {
          rethrow;
        }

        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        return credential.user!;
      }
    } on FirebaseAuthException catch (e) {
      log(
        "Error in FirebaseAuthServices.signInWithEmailAndPassword: $e code: ${e.code} message: ${e.message} ",
      );
      if (e.code == 'user-not-found') {
        throw CustomException(
          message: 'There is a problem in email or password',
        );
      } else if (e.code == 'wrong-password') {
        throw CustomException(
          message: 'There is a problem in email or password',
        );
      } else if (e.code == 'network-request-failed') {
        throw CustomException(
          message:
              'Network request failed, please check your internet connection.',
        );
      } else if (e.code == 'invalid-email') {
        throw CustomException(message: 'The email address is not valid.');
      } else {
        throw CustomException(
          message: 'There is a problem in email or password',
        );
      }
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        serverClientId:
            '351864218835-ivc4ah3rapu06hcq1nofs0mf53gqoj14.apps.googleusercontent.com',
      );

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      return userCredential.user!;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw CustomException(message: 'Sign-in cancelled by user');
      } else {
        throw CustomException(
          message: 'Google Sign-In failed: ${e.description}',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message ?? 'Firebase auth failed');
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  Future<User> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: const ['email', 'public_profile'],
      );

      switch (loginResult.status) {
        case LoginStatus.success:
          final token = loginResult.accessToken?.tokenString;
          if (token == null || token.isEmpty) {
            throw CustomException(message: 'Facebook Sign-In failed');
          }

          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(token);

          return (await FirebaseAuth.instance.signInWithCredential(
            facebookAuthCredential,
          )).user!;
        case LoginStatus.cancelled:
          throw CustomException(message: 'Sign-in cancelled by user');
        case LoginStatus.failed:
          throw CustomException(
            message: (loginResult.message ?? '').trim().isNotEmpty
                ? loginResult.message!
                : 'Facebook Sign-In failed',
          );
        case LoginStatus.operationInProgress:
          throw CustomException(
            message: 'Facebook sign-in is already in progress',
          );
      }
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message ?? 'Facebook Sign-In failed');
    } catch (e) {
      if (e is CustomException) rethrow;
      throw CustomException(message: 'Facebook Sign-In failed');
    }
  }

  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }
}
