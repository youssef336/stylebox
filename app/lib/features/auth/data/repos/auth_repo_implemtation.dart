// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stylebox/constant.dart';
import 'package:stylebox/core/errors/exception.dart';
import 'package:stylebox/core/errors/failures.dart';
import 'package:stylebox/core/services/database_servies.dart';
import 'package:stylebox/core/services/firebase_auth_services.dart';
import 'package:stylebox/core/services/shared_preferences_singletone.dart';
import 'package:stylebox/core/utils/back_end_endpoints.dart';
import 'package:stylebox/core/utils/hash_helper.dart';
import 'package:stylebox/features/auth/data/models/user_model.dart';
import 'package:stylebox/features/auth/domains/entities/user_entity.dart';
import 'package:stylebox/features/auth/domains/repos/auth_repo.dart';

class AuthRepoImplemtation extends AuthRepo {
  final FirebaseAuthServices firebaseAuthServices;
  final DatabaseServies databaseServies;
  AuthRepoImplemtation({
    required this.databaseServies,
    required this.firebaseAuthServices,
  });
  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    User? user;
    try {
      user = await firebaseAuthServices.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userEntity = UserEntity(
        id: user.uid,
        name: name,
        email: email,
        passwordHash: HashHelper.passwordHash(password),
      );
      await addUserData(user: userEntity);
      await saveUserData(user: userEntity);
      return right(userEntity);
    } on CustomException catch (e) {
      await DeleteUser(user);
      return Left(ServerFailure(e.message));
    } catch (e) {
      await DeleteUser(user);
      log("Error in AuthRepoImplemtation.createUserWithEmailAndPassword: $e");
      return const Left(
        ServerFailure('An unknown error occurred please try again later.'),
      );
    }
  }

  Future<void> DeleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthServices.deleteUser();
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      var user = await firebaseAuthServices.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userEntity = await getUserData(uId: user.uid);
      await saveUserData(user: userEntity);
      return right(userEntity);
    } on CustomException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      log("Error in AuthRepoImplemtation.signInWithEmailAndPassword: $e");
      return const Left(
        ServerFailure('An unknown error occurred please try again later.'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    User? user;
    try {
      user = await firebaseAuthServices.signInWithGoogle();
      var userEntity = UserModel.fromFireabaseUser(user);
      await saveUserData(user: userEntity);
      var isUserExists = await databaseServies.checkifDataExists(
        path: BackEndEndpoints.checkifUserDataExists,
        documentId: user.uid,
      );
      if (isUserExists) {
        await getUserData(uId: user.uid);
      } else {
        await addUserData(user: userEntity);
      }

      return right(userEntity);
    } catch (e) {
      await DeleteUser(user);
      log("Error in AuthRepoImplemtation.signInWithGoogle: $e");
      return const Left(
        ServerFailure('An unknown error occurred please try again later.'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async {
    User? user;
    try {
      user = await firebaseAuthServices.signInWithFacebook();
      var userEntity = UserModel.fromFireabaseUser(user);
      await saveUserData(user: userEntity);

      var isUserExists = await databaseServies.checkifDataExists(
        path: BackEndEndpoints.checkifUserDataExists,
        documentId: user.uid,
      );
      if (isUserExists) {
        await getUserData(uId: user.uid);
      } else {
        await addUserData(user: userEntity);
      }
      return right(userEntity);
    } on CustomException catch (e) {
      await DeleteUser(user);
      return Left(ServerFailure(e.message));
    } catch (e) {
      await DeleteUser(user);
      log("Error in AuthRepoImplemtation.signInWithFacebook: $e");
      return const Left(
        ServerFailure('An unknown error occurred please try again later.'),
      );
    }
  }

  @override
  Future addUserData({required UserEntity user}) async {
    await databaseServies.addData(
      path: BackEndEndpoints.addUserData,
      data: UserModel.fromEntity(user).toMap(),
      documentId: user.id,
    );
  }

  @override
  Future<UserEntity> getUserData({required String uId}) async {
    var userData = await databaseServies.getData(
      path: BackEndEndpoints.getUserData,
      docuementId: uId,
    );
    return UserModel.fromJson(userData);
  }

  @override
  Future saveUserData({required UserEntity user}) async {
    var jsonData = jsonEncode(UserModel.fromEntity(user).toMap());
    await Prefs.setString(KUserData, jsonData);
  }
}
