import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/repo/userrepository.dart';
import 'package:assignment_sem6/util/validation.dart';

class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl({required super.dao});

  @override
  Future<User?> getByEmail(String email) async {
    if (Validation.isValidEmail(email) != EmailValidationResult.valid) {
      throw ArgumentError("Invalid email.");
    }
    return await dao.findByEmail(email);
  }

  @override
  Future<User?> getByUsername(String username) async {
    if (Validation.isValidUsername(username) !=
        UsernameValidationResult.valid) {
      throw ArgumentError("Invalid username.");
    }
    return await dao.findByUsername(username);
  }
}
