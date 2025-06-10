import 'package:assignment_sem6/util/uuid.dart';
import 'package:test/test.dart';

void main() {
  group("generate", () {
    test("generates unique values", () {
      var found = [];

      for (var i = 0; i < 1000; i++) {
        String uuid = UUIDv4.generate();
        expect(found.contains(uuid), isFalse);
        found.add(uuid);
      }
    });

    test("generates valid values", () {
      String uuid = UUIDv4.generate();

      expect(UUIDv4.isValid(uuid), isTrue);
    });
  });

  group("isValid", () {
    test("returns true for valid v4 UUIDs", () {
      final validUuids = [
        "3ab419ca-be7f-473d-816a-994aa714a4ab",
        "ad7e27bb-4446-46cb-9424-ae13ad929de5",
        UUIDv4.generate(),
      ];

      for (var uuid in validUuids) {
        expect(
          UUIDv4.isValid(uuid),
          isTrue,
          reason: "Expected $uuid to be valid, but was invalid.",
        );
      }
    });

    test("returns false for invalid v4 UUIDs", () {
      const invalidUuids = [
        "not a uuid",
        "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa", // Correct length but invalid
        "3ab419cabe7f473d816a994aa714a4ab", // No dashes
        "",
      ];

      for (var uuid in invalidUuids) {
        expect(
          UUIDv4.isValid(uuid),
          isFalse,
          reason: "Expected $uuid to be invalid, but was valid.",
        );
      }
    });
  });
}
