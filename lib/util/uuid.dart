import 'package:uuid/uuid.dart';

class UUIDv4 {
  static const _uuid = Uuid();
  static String generate() => _uuid.v4();
  static bool isValid(String uuid) => Uuid.isValidUUID(fromString: uuid);
}
