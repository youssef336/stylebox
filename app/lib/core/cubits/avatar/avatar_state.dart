part of 'avatar_cubit.dart';

abstract class AvatarState extends Equatable {
  const AvatarState();

  @override
  List<Object> get props => [];
}

class AvatarInitial extends AvatarState {}

class ChangeAvatar extends AvatarState {
  final String avatar;
  const ChangeAvatar(this.avatar);
  @override
  List<Object> get props => [avatar];
}
