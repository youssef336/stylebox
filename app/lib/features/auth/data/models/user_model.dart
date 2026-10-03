import 'package:firebase_auth/firebase_auth.dart';

import 'package:stylebox/features/auth/domains/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.passwordHash,
  });

  factory UserModel.fromFireabaseUser(User user) {
    return UserModel(
      id: user.uid,
      name: user.displayName ?? 'No Name',
      email: user.email ?? 'No Email',
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String?,
    );
  }

  factory UserModel.fromEntity(UserEntity userEntity) {
    return UserModel(
      id: userEntity.id,
      name: userEntity.name,
      email: userEntity.email,
      passwordHash: userEntity.passwordHash,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (passwordHash != null) 'passwordHash': passwordHash,
    };
  }
}
