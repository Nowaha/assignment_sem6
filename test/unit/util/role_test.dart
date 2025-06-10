import 'package:assignment_sem6/util/role.dart';
import 'package:test/test.dart';

void main() {
  group("fromName", () {
    test("finds the correct roles for each name", () {
      const matches = {
        "regular": Role.regular,
        "moderator": Role.moderator,
        "administrator": Role.administrator,
        "operator": null,
        "Regular": null,
      };

      matches.forEach(
        (name, expected) => expect(Role.fromName(name), expected),
      );
    });
  });
}
