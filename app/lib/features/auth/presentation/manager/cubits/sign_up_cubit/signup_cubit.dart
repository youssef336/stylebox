// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:stylebox/features/auth/domains/entities/user_entity.dart';
import 'package:stylebox/features/auth/domains/repos/auth_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupCubitState> {
  SignupCubit(this.authRepo) : super(SignupCubitInitial());
  final AuthRepo authRepo;
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(SignupCubitLoading());
    final result = await authRepo.createUserWithEmailAndPassword(
      email,
      password,
      name,
    );
    result.fold(
      (failure) => emit(SignupCubitError(failure.message)),
      (user) => emit(SignupCubitSuccess(user)),
    );
  }
}
