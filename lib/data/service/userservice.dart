import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/repo/userrepository.dart';
import 'package:assignment_sem6/data/service/service.dart';

abstract class UserService extends Service<User, UserRepository> {
  @override
  final UserRepository repository;

  UserService({required this.repository});

  Future<User?> getByUsername(String username);
  Future<User?> getByEmail(String email);
}
