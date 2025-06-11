import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/repo/userrepository.dart';
import 'package:assignment_sem6/data/service/singlestreamservice.dart';
import 'package:assignment_sem6/util/role.dart';

abstract class UserService extends SingleStreamService<User, UserRepository> {
  @override
  final UserRepository repository;

  UserService({required this.repository});

  Future<User?> getByUsername(String username);
  Future<User?> getByEmail(String email);

  Future<bool> existsByUUID(String uuid);
  Future<bool> existsByEmail(String email);
  Future<bool> existsByUsername(String username);

  Future<User> registerNewUser({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String plainTextPassword,
    Role role = Role.regular,
  });

  Future<User> updateDetails({
    required String uuid,
    String? firstName,
    String? lastName,
  });
  Future<User> updatePassword(String uuid, String plainTextPassword);
  Future<User> updateEmail(String uuid, String email);

  Future<User?> authenticateByUsername(
    String username,
    String plainTextPassword,
  );
  Future<User?> authenticateByEmail(String email, String plainTextPassword);

  Future<bool> deleteUser(String uuid);
}
