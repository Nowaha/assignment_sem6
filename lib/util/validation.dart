import 'package:assignment_sem6/util/uuid.dart';

class Validation {
  static bool isValidUUID(String uuid) => UUIDv4.isValid(uuid);
  static bool isValidEmail(String email) => true;
  static bool isValidUsername(String username) => true;
}