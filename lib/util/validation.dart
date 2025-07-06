// ignore_for_file: curly_braces_in_flow_control_structures

class Validation {
  static const int minNameLength = 2;
  static const int maxNameLength = 24;
  static const int minUsernameLength = 4;
  static const int maxUsernameLength = 24;
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minGroupNameLength = 2;
  static const int maxGroupNameLength = 12;
  static const int minPostTitleLength = 4;
  static const int maxPostTitleLength = 64;
  static const int minPostContentsLength = 10;
  static const int maxPostContentsLength = 5000;
  static const int maxPostTags = 5;
  static const int maxPostGroups = 6;
  static const int minCommentLength = 4;
  static const int maxCommentLength = 1000;
  static const int maxLongLatDecimalPlaces = 6;

  static final characterWhitelistRegex = RegExp(r'^[a-zA-Z0-9_]+$');
  static final emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );
  static final allowedPasswordRegex = RegExp(
    r'^[A-Za-z0-9!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]+$',
  );
  static final postTitleCharacterWhitelistRegex = RegExp(
    r'^[a-zA-Z0-9_.?!-\\ ]+$',
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

  static GroupNameValidationResult isValidGroupName(String name) {
    if (name.isEmpty) return GroupNameValidationResult.empty;
    if (name.length < minGroupNameLength)
      return GroupNameValidationResult.tooShort;
    if (name.length > maxGroupNameLength)
      return GroupNameValidationResult.tooLong;
    if (!characterWhitelistRegex.hasMatch(name)) {
      return GroupNameValidationResult.invalidCharacters;
    }
    return GroupNameValidationResult.valid;
  }

  static PostTitleValidationResult isValidPostName(String name) {
    if (name.isEmpty) return PostTitleValidationResult.empty;
    if (name.length < minPostTitleLength)
      return PostTitleValidationResult.tooShort;
    if (name.length > maxPostTitleLength)
      return PostTitleValidationResult.tooLong;
    if (!postTitleCharacterWhitelistRegex.hasMatch(name)) {
      return PostTitleValidationResult.invalidCharacters;
    }
    return PostTitleValidationResult.valid;
  }

  static PostContentsValidationResult isValidPostContents(String contents) {
    if (contents.isEmpty) return PostContentsValidationResult.empty;
    if (contents.length < minPostContentsLength)
      return PostContentsValidationResult.tooShort;
    if (contents.length > maxPostContentsLength)
      return PostContentsValidationResult.tooLong;
    return PostContentsValidationResult.valid;
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
    if (password.length < minPasswordLength)
      return PasswordValidationResult.tooShort;
    if (password.length > maxPasswordLength)
      return PasswordValidationResult.tooLong;
    if (!allowedPasswordRegex.hasMatch(password)) {
      return PasswordValidationResult.invalidCharacters;
    }

    return PasswordValidationResult.valid;
  }

  static UsernameValidationResult isValidUsername(String username) {
    if (username.isEmpty) return UsernameValidationResult.empty;
    if (username.length < minUsernameLength)
      return UsernameValidationResult.tooShort;
    if (username.length > maxUsernameLength)
      return UsernameValidationResult.tooLong;
    if (!characterWhitelistRegex.hasMatch(username)) {
      return UsernameValidationResult.invalidCharacters;
    }

    return UsernameValidationResult.valid;
  }

  static LatitudeValidationResult isValidLatitude(String latitude) {
    if (latitude.isEmpty) return LatitudeValidationResult.empty;
    final double? value = double.tryParse(latitude);
    if (value == null) return LatitudeValidationResult.notANumber;
    print(value.toStringAsFixed(maxLongLatDecimalPlaces));
    if (value.toString().length >
        value.toStringAsFixed(maxLongLatDecimalPlaces).length)
      return LatitudeValidationResult.tooManyDecimals;
    if (value < -90 || value > 90) return LatitudeValidationResult.invalid;
    return LatitudeValidationResult.valid;
  }

  static LongitudeValidationResult isValidLongitude(String longitude) {
    if (longitude.isEmpty) return LongitudeValidationResult.empty;
    final double? value = double.tryParse(longitude);
    if (value == null) return LongitudeValidationResult.notANumber;
    if (value.toString().length >
        value.toStringAsFixed(maxLongLatDecimalPlaces).length)
      return LongitudeValidationResult.tooManyDecimals;
    if (value < -180 || value > 180) return LongitudeValidationResult.invalid;
    return LongitudeValidationResult.valid;
  }

  static CommentValidationResult isValidComment(String comment) {
    if (comment.isEmpty) return CommentValidationResult.empty;
    if (comment.length < minCommentLength)
      return CommentValidationResult.tooShort;
    if (comment.length > maxCommentLength)
      return CommentValidationResult.tooLong;
    return CommentValidationResult.valid;
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

enum GroupNameValidationResult {
  valid,
  empty(message: "Group name cannot be empty."),
  tooShort(
    message: "Group name is too short (${Validation.minGroupNameLength}).",
  ),
  tooLong(
    message: "Group name is too long (${Validation.maxGroupNameLength}).",
  ),
  invalidCharacters(message: "Group name contains invalid characters.");

  final String? message;

  const GroupNameValidationResult({this.message});
}

enum PostTitleValidationResult {
  valid,
  empty(message: "Post title cannot be empty."),
  tooShort(
    message: "Post title is too short (${Validation.minPostTitleLength}).",
  ),
  tooLong(
    message: "Post title is too long (${Validation.maxPostTitleLength}).",
  ),
  invalidCharacters(message: "Post title contains invalid characters.");

  final String? message;

  const PostTitleValidationResult({this.message});
}

enum PostContentsValidationResult {
  valid,
  empty(message: "Post contents cannot be empty."),
  tooShort(
    message:
        "Post contents are too short (${Validation.minPostContentsLength}).",
  ),
  tooLong(
    message:
        "Post contents are too long (${Validation.maxPostContentsLength}).",
  );

  final String? message;

  const PostContentsValidationResult({this.message});
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

enum LongitudeValidationResult {
  valid,
  notANumber(message: "Longitude must be a number."),
  invalid(message: "Longitude must be between -180 and 180 degrees."),
  tooManyDecimals(message: "Longitude cannot have more than 6 decimal places."),
  empty(message: "Longitude cannot be empty.");

  final String? message;

  const LongitudeValidationResult({this.message});
}

enum LatitudeValidationResult {
  valid,
  notANumber(message: "Latitude must be a number."),
  invalid(message: "Latitude must be between -90 and 90 degrees."),
  tooManyDecimals(message: "Latitude cannot have more than 6 decimal places."),
  empty(message: "Latitude cannot be empty.");

  final String? message;

  const LatitudeValidationResult({this.message});
}

enum CommentValidationResult {
  valid,
  empty(message: "Comment cannot be empty."),
  tooShort(message: "Comment is too short (${Validation.minCommentLength})."),
  tooLong(message: "Comment is too long (${Validation.maxCommentLength}).");

  final String? message;

  const CommentValidationResult({this.message});
}
