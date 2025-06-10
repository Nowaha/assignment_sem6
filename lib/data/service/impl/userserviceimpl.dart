import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/service/userservice.dart';

class UserServiceImpl extends UserService {
  UserServiceImpl({required super.repository});

  @override
  Future<User?> getByEmail(String email) => repository.getByEmail(email);

  @override
  Future<User?> getByUsername(String username) => repository.getByUsername(username);
}