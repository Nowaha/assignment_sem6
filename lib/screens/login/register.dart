import 'package:assignment_sem6/data/service/userservice.dart';
import 'package:assignment_sem6/mixin/toastmixin.dart';
import 'package:assignment_sem6/screens/login/login.dart';
import 'package:assignment_sem6/util/validation.dart';
import 'package:assignment_sem6/widgets/sizedcircularprogressindicator.dart';
import 'package:assignment_sem6/widgets/textinput.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = "register";

  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with ToastMixin {
  final Map<TextEditingController, String? Function(String input)> _validators =
      {};
  final Map<TextEditingController, String> _errors = {};
  bool _loading = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  @override
  void initState() {
    super.initState();

    String? validatePassword(String input) {
      final result = Validation.isValidPassword(input);

      if (result != PasswordValidationResult.valid) {
        return result.message;
      }

      if (input != passwordConfirmController.text) {
        return "Passwords do not match.";
      }

      return null;
    }

    _validators.addAll({
      firstNameController: (input) => Validation.isValidName(input).message,
      lastNameController: (input) => Validation.isValidName(input).message,
      usernameController: (input) => Validation.isValidUsername(input).message,
      emailController: (input) => Validation.isValidEmail(input).message,
      passwordController: validatePassword,
      passwordConfirmController: validatePassword,
    });
  }

  bool _validate() {
    _errors.clear();

    _validators.forEach((controller, validator) {
      String? error = validator(controller.text);
      if (error != null) {
        _errors[controller] = error;
      }
    });

    return _errors.isEmpty;
  }

  void _attemptToRegister(BuildContext context) async {
    if (_loading) return;
    _loading = true;

    setState(() {
      _errors.clear();
    });

    if (!_validate()) {
      setState(() {
        _loading = false;
      });
      return;
    }

    final userService = context.read<UserService>();

    try {
      await userService.registerNewUser(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        username: usernameController.text,
        email: emailController.text,
        plainTextPassword: passwordController.text,
      );

      showToast(
        "Registration successful! You can now log in.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );

      if (context.mounted) {
        context.goNamed(LoginPage.routeName);
      }
    } on ArgumentError catch (error) {
      final TextEditingController controller = switch (error.name) {
        "firstName" => firstNameController,
        "lastName" => lastNameController,
        "username" => usernameController,
        "email" => emailController,
        "password" => passwordController,
        _ => usernameController,
      };

      _errors[controller] = error.message;
    } catch (error) {
      _errors[usernameController] = "An error occurred. Please try again.";
      print("Error during registration: $error");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _clearError(TextEditingController? controller) {
    if (controller == null) {
      if (_errors.isNotEmpty) {
        setState(() => _errors.clear());
      }
      return;
    }

    if (_errors.containsKey(controller)) {
      setState(() => _errors.remove(controller));
    }
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
  }

  Widget _buildFormTextInput(
    String label,
    TextEditingController controller, {
    bool expand = false,
    bool? obscure,
  }) => TextInput(
    label: label,
    controller: controller,
    enabled: !_loading,
    errorText: _errors[controller],
    onChanged: (_) => _clearError(controller),
    obscure: obscure,
    expand: expand,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final loginIcon =
        !_loading
            ? Icon(Icons.login)
            : SizedCircularProgressIndicator.square(
              size: 14,
              strokeWidth: 2,
              onPrimary: true,
            );

    return Scaffold(
      appBar: AppBar(title: const Text("Semester 6")),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            width: 360,
            child: Column(
              spacing: 16,
              children: [
                Text("Register", style: theme.textTheme.headlineLarge),
                Text(
                  "Create a new account by entering your details in the fields below.",
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text("Personal Details", style: theme.textTheme.labelLarge),
                    _buildFormTextInput("Username", usernameController),
                  ],
                ),

                Row(
                  spacing: 16,
                  children: [
                    _buildFormTextInput(
                      "First Name",
                      firstNameController,
                      expand: true,
                    ),
                    _buildFormTextInput(
                      "Last Name",
                      lastNameController,
                      expand: true,
                    ),
                  ],
                ),

                _buildFormTextInput("Email Address", emailController),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text("Password", style: theme.textTheme.labelLarge),
                    _buildFormTextInput(
                      "Password",
                      passwordController,
                      obscure: true,
                    ),
                    _buildFormTextInput(
                      "Confirm Password",
                      passwordConfirmController,
                      obscure: true,
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed:
                          !_loading
                              ? () => context.goNamed(LoginPage.routeName)
                              : null,
                      child: Text("Log in"),
                    ),
                    FilledButton.icon(
                      onPressed: () => _attemptToRegister(context),
                      label: Text("Register"),
                      icon: loginIcon,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
