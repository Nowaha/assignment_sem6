import 'package:assignment_sem6/data/entity/entity.dart';
import 'package:assignment_sem6/util/password.dart';
import 'package:assignment_sem6/util/role.dart';
import 'package:assignment_sem6/util/uuid.dart';

class User implements Entity {
  final String uuid; // Unique
  final int creationTimestamp;
  final String username; // Unique
  final String firstName;
  final String lastName;
  final String email; // Unique
  final String hashedPassword;
  final Role role;

  User({
    required this.uuid,
    required this.creationTimestamp,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.hashedPassword,
    required this.role,
  });

  User cloneWithChanges({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? hashedPassword,
    Role? role,
  }) => User(
    uuid: uuid,
    creationTimestamp: creationTimestamp,
    username: username ?? this.username,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    hashedPassword: hashedPassword ?? this.hashedPassword,
    role: role ?? this.role,
  );

  static User newUser({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String plainTextPassword,
    Role role = Role.regular,
  }) => User(
    uuid: UUIDv4.generate(),
    creationTimestamp: DateTime.now().millisecondsSinceEpoch,
    username: username,
    firstName: firstName,
    lastName: lastName,
    email: email,
    hashedPassword: Password.hash(plainTextPassword),
    role: role,
  );
}
