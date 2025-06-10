import 'package:bcrypt/bcrypt.dart';

class Password {
  static String hash(String plainTextPassword, {String? salt}) =>
      BCrypt.hashpw(plainTextPassword, salt ?? BCrypt.gensalt());

  static bool checkPassword(String plainTextPassword, String hashedPassword) =>
      BCrypt.checkpw(plainTextPassword, hashedPassword);
}
