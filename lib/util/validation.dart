class Validation {
  static const int minNameLength = 2;
  static const int maxNameLength = 24;
  static const int minUsernameLength = 4;
  static const int maxUsernameLength = 24;
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;

  static final characterWhitelistRegex = RegExp(r'^[a-zA-Z0-9_]+$');
  static final emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );
  static final allowedPasswordRegex = RegExp(
    r'^[A-Za-z0-9!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]+$',
  );

  static NameValidationResult isValidName(String name) {
    if (name.isEmpty) return NameValidationResult.empty;
    if (name.length < minNameLength) return NameValidationResult.tooShort;
    if (name.length > maxNameLength) return NameValidationResult.tooLong;
    if (!characterWhitelistRegex.hasMatch(name)) {
      return NameValidationResult.invalidCharacters;
    }
    return NameValidationResult.valid;
  }

  static EmailValidationResult isValidEmail(String email) {
    if (email.isEmpty) return EmailValidationResult.empty;
    if (!emailRegex.hasMatch(email)) {
      return EmailValidationResult.invalidFormat;
    }
    return EmailValidationResult.valid;
  }

  static PasswordValidationResult isValidPassword(String password) {
    if (password.isEmpty) return PasswordValidationResult.tooShort;
    if (password.length < minPasswordLength) return PasswordValidationResult.tooShort;
    if (password.length > maxPasswordLength) return PasswordValidationResult.tooLong;
    if (!allowedPasswordRegex.hasMatch(password)) {
      return PasswordValidationResult.invalidCharacters;
    }

    return PasswordValidationResult.valid;
  }

  static UsernameValidationResult isValidUsername(String username) {
    if (username.isEmpty) return UsernameValidationResult.empty;
    if (username.length < minUsernameLength) return UsernameValidationResult.tooShort;
    if (username.length > maxUsernameLength) return UsernameValidationResult.tooLong;
    if (!characterWhitelistRegex.hasMatch(username)) {
      return UsernameValidationResult.invalidCharacters;
    }

    return UsernameValidationResult.valid;
  }
}

enum NameValidationResult {
  valid,
  empty(message: "Name cannot be empty."),
  tooShort(message: "Name is too short (${Validation.minNameLength})."),
  tooLong(message: "Name is too long (${Validation.maxNameLength})."),
  invalidCharacters(message: "Name contains invalid characters.");

  final String? message;

  const NameValidationResult({this.message});
}

enum EmailValidationResult {
  valid,
  empty(message: "Email cannot be empty."),
  invalidFormat(message: "Email format is invalid.");

  final String? message;

  const EmailValidationResult({this.message});
}

enum PasswordValidationResult {
  valid,
  tooShort(message: "Password is too short (${Validation.minPasswordLength})."),
  tooLong(message: "Password is too long (${Validation.maxPasswordLength})."),
  invalidCharacters(message: "Password contains invalid characters.");

  final String? message;

  const PasswordValidationResult({this.message});
}

enum UsernameValidationResult {
  valid,
  empty(message: "Username cannot be empty."),
  invalidCharacters(message: "Username contains invalid characters."),
  tooShort(message: "Username is too short (${Validation.minUsernameLength})."),
  tooLong(message: "Username is too long (${Validation.maxUsernameLength}).");

  final String? message;

  const UsernameValidationResult({this.message});
}
