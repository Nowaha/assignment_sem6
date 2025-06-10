import 'package:assignment_sem6/data/dao/userdao.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/repo/repository.dart';

abstract class UserRepository extends Repository<User, UserDao> {
  @override
  final UserDao dao;

  UserRepository({required this.dao});

  Future<User?> getByUsername(String username);
  Future<User?> getByEmail(String email);
}
