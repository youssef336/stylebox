part of 'signup_cubit.dart';

@immutable
sealed class SignupCubitState {}

final class SignupCubitInitial extends SignupCubitState {}

final class SignupCubitLoading extends SignupCubitState {}

final class SignupCubitSuccess extends SignupCubitState {
  final UserEntity user;

  SignupCubitSuccess(this.user);
}

final class SignupCubitError extends SignupCubitState {
  final String message;
  SignupCubitError(this.message);
}
