import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/service/userservice.dart';
import 'package:assignment_sem6/util/password.dart';
import 'package:assignment_sem6/util/role.dart';
import 'package:assignment_sem6/util/validation.dart';

class UserServiceImpl extends UserService {
  UserServiceImpl({required super.repository});

  @override
  Future<User?> getByEmail(String email) => repository.getByEmail(email);

  @override
  Future<User?> getByUsername(String username) =>
      repository.getByUsername(username);

  @override
  Future<bool> existsByEmail(String email) async =>
      (await repository.getByEmail(email)) != null;

  @override
  Future<bool> existsByUUID(String uuid) async =>
      (await repository.getByUUID(uuid)) != null;

  @override
  Future<bool> existsByUsername(String username) async =>
      (await repository.getByUsername(username)) != null;

  @override
  Future<User> registerNewUser({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String plainTextPassword,
    Role role = Role.regular,
  }) async {
    if (Validation.isValidName(firstName) != NameValidationResult.valid) {
      throw ArgumentError("First name is invalid.", "firstName");
    }

    if (Validation.isValidName(lastName) != NameValidationResult.valid) {
      throw ArgumentError("Last name is invalid.", "lastName");
    }

    if (Validation.isValidEmail(email) != EmailValidationResult.valid) {
      throw ArgumentError("Email is invalid.", "email");
    }

    if (await existsByUsername(username)) {
      throw ArgumentError("Username is already taken.", "username");
    }

    if (await existsByEmail(email)) {
      throw ArgumentError("Email is already taken.", "email");
    }

    User newUser = User.newUser(
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      plainTextPassword: plainTextPassword,
      role: role,
    );
    await repository.add(newUser);
    return newUser;
  }

  @override
  Future<User> updateDetails({
    required String uuid,
    String? firstName,
    String? lastName,
  }) async {
    if (firstName != null &&
        Validation.isValidName(firstName) != NameValidationResult.valid) {
      throw ArgumentError("First name is invalid.", "firstName");
    }

    if (lastName != null &&
        Validation.isValidName(lastName) != NameValidationResult.valid) {
      throw ArgumentError("Last name is invalid.", "lastName");
    }

    User? user = await getByUUID(uuid);
    if (user == null) {
      throw ArgumentError("UUID does not belong to any user.", "uuid");
    }

    User newUser = user.cloneWithChanges(
      firstName: firstName,
      lastName: lastName,
    );
    repository.update(newUser);
    return newUser;
  }

  @override
  Future<User> updateEmail(String uuid, String email) async {
    if (Validation.isValidEmail(email) != EmailValidationResult.valid) {
      throw ArgumentError("Email is invalid.", "email");
    }

    User? user = await getByUUID(uuid);
    if (user == null) {
      throw ArgumentError("UUID does not belong to any user.", "uuid");
    }

    User newUser = user.cloneWithChanges(email: email);
    repository.update(newUser);
    return newUser;
  }

  @override
  Future<User> updatePassword(String uuid, String plainTextPassword) async {
    if (Validation.isValidPassword(plainTextPassword) !=
        PasswordValidationResult.valid) {
      throw ArgumentError("Password is invalid.", "plainTextPassword");
    }

    User? user = await getByUUID(uuid);
    if (user == null) {
      throw ArgumentError("UUID does not belong to any user.", "uuid");
    }

    User newUser = user.cloneWithChanges(
      hashedPassword: Password.hash(plainTextPassword),
    );
    repository.update(newUser);
    return newUser;
  }

  bool _authenticate(User user, String plainTextPassword) =>
      Password.checkPassword(plainTextPassword, user.hashedPassword);

  @override
  Future<User?> authenticateByEmail(
    String email,
    String plainTextPassword,
  ) async {
    User? user = await getByEmail(email);
    if (user == null) {
      return null;
    }

    if (_authenticate(user, plainTextPassword)) {
      return user;
    }

    return null;
  }

  @override
  Future<User?> authenticateByUsername(
    String username,
    String plainTextPassword,
  ) async {
    User? user = await getByUsername(username);
    if (user == null) {
      return null;
    }

    if (_authenticate(user, plainTextPassword)) {
      return user;
    }

    return null;
  }

  @override
  Future<bool> deleteUser(String uuid) => repository.remove(uuid);

  @override
  void dispose() => repository.dispose();

  @override
  Stream<List<User>> get stream => repository.stream;
}
