import 'package:flutter_test/flutter_test.dart';

import 'testableloginscreen.dart';

class Attempt {
  final String username;
  final String password;
  final bool valid;

  Attempt({
    required this.username,
    required this.password,
    required this.valid,
  });
}

void main() {
  const String errorText = "Invalid username or password.";
  const String validUsername = "validUser";
  const String validEmail = "validuser@example.com";
  const String validPassword = "validPass";
  final List<Attempt> attempts = [
    Attempt(username: validUsername, password: validPassword, valid: true),
    Attempt(username: "invalidUser", password: validPassword, valid: false),
    Attempt(username: validUsername, password: "invalidPass", valid: false),
    Attempt(username: "invalidUser", password: "invalidPass", valid: false),
    Attempt(username: validEmail, password: validPassword, valid: true),
  ];

  testWidgets("Login only works with valid username and password", (
    WidgetTester tester,
  ) async {
    // Arrange
    final String username = validUsername;
    final String email = validEmail;
    final String password = validPassword;
    final screen = TestableLoginScreen(tester: tester);
    final user = await screen.createUser(
      username: username,
      email: email,
      plainTextPassword: password,
    );
    await screen.pump();

    for (final attempt in attempts) {
      try {
        // Act
        await screen.enterUsername(attempt.username);
        await screen.enterPassword(attempt.password);
        await screen.tapSubmit();

        // Assert
        if (attempt.valid) {
          await screen.expectNoErrorText(errorText);
          expect(screen.authState.getCurrentUser, user);
        } else {
          await screen.expectErrorText(errorText);
          expect(screen.authState.getCurrentUser, isNull);
        }

        screen.authState.logout();
      } catch (e) {
        print(
          "Failed for attempt: ${attempt.username} / ${attempt.password}, expecting valid: ${attempt.valid}",
        );
        rethrow;
      }
    }
  });
}
