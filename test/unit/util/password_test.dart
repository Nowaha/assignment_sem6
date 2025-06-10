import 'package:assignment_sem6/util/password.dart';
import 'package:test/test.dart';

void main() {
  group("hash", () {
    test("hashes", () async {
      const plainText = "password123";

      String hashed = Password.hash(plainText);

      expect(hashed, isNot(plainText));
    });

    test("generates unique values for differing passwords", () async {
      const plainText1 = "password123";
      const plainText2 = "password456";

      String hashed1 = Password.hash(plainText1);
      String hashed2 = Password.hash(plainText2);

      expect(hashed1, isNot(hashed2));
    });

    test("generates unique values for identical passwords", () async {
      const plainText = "password123";

      String hashed1 = Password.hash(plainText);
      String hashed2 = Password.hash(plainText);

      expect(hashed1, isNot(hashed2));
    });
  });

  group("checkPassword", () {
    test("returns true for correct input", () {
      const plainText = "password123";
      String hashed = Password.hash(plainText);

      expect(Password.checkPassword(plainText, hashed), isTrue);
    });

    test("returns false for incorrect input", () {
      const incorrectGuesses = [
        "password",
        "password12",
        "",
        "Password123",
        " password123",
        "password123 ",
        "entirely different",
      ];
      const plainText = "password123";
      String hashed = Password.hash(plainText);

      for (final guess in incorrectGuesses) {
        expect(
          Password.checkPassword(guess, hashed),
          isFalse,
          reason: 'Expected "$guess" to be false, but passed.',
        );
      }
    });
  });
}
