import 'package:dartz/dartz.dart';
import 'package:stylebox_dashboard/core/errors/failures.dart';
import 'package:stylebox_dashboard/core/services/app_user.dart';

abstract class LoginRepo {
  Future<Either<Failure, AppUser>> login(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AppUser?>> checkAuthStatus();
}
