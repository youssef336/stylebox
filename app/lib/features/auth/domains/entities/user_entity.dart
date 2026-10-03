class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? password;
  final String? passwordHash;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.passwordHash,
  });
}
