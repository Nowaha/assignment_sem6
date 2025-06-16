import 'dart:math';

import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/service/userservice.dart';
import 'package:assignment_sem6/screens/register.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/widgets/sizedcircularprogressindicator.dart';
import 'package:assignment_sem6/widgets/textinput.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "login";

  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _error;
  bool _loading = false;

  final usernameEmailController = TextEditingController();
  final passwordController = TextEditingController();

  void _attemptToAuthenticate(BuildContext context) async {
    if (_loading) return;
    _loading = true;
    setState(() {
      _error = null;
    });

    final authState = context.read<AuthState>();
    final userService = context.read<UserService>();

    await Future.delayed(Duration(milliseconds: Random().nextInt(1000) + 250));

    try {
      User? authenticatedUser;

      try {
        authenticatedUser = await userService.authenticateByUsername(
          usernameEmailController.text,
          passwordController.text,
        );
        // ignore: empty_catches
      } catch (error) {}

      if (authenticatedUser == null) {
        try {
          authenticatedUser ??= await userService.authenticateByEmail(
            usernameEmailController.text,
            passwordController.text,
          );
          // ignore: empty_catches
        } catch (error) {}
      }

      if (authenticatedUser != null) {
        authState.login(authenticatedUser);
        return;
      }

      setState(() {
        _loading = false;
        _error = "Invalid username or password, please try again.";
      });
    } catch (error) {
      setState(() {
        _loading = false;
        _error = "An error occurred. Please try again.";
        print("Error during authentication: $error");
      });
    }
  }

  void _clearError() {
    if (_error == null) return;

    setState(() {
      _error = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    usernameEmailController.dispose();
    passwordController.dispose();
  }

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
      body: Center(
        child: SizedBox(
          width: 360,
          child: Column(
            spacing: 16,
            children: [
              Text("Log in", style: theme.textTheme.headlineLarge),
              Text(
                "Please enter your username/email address and password to log in to your personal account.",
              ),
              TextInput(
                label: "Username / Email Address",
                controller: usernameEmailController,
                enabled: !_loading,
                errorText: _error,
                onChanged: (_) => _clearError(),
              ),
              TextInput(
                label: "Password",
                controller: passwordController,
                enabled: !_loading,
                obscure: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed:
                        !_loading
                            ? () => context.goNamed(RegisterPage.routeName)
                            : null,
                    child: Text("Register"),
                  ),
                  FilledButton.icon(
                    onPressed: () => _attemptToAuthenticate(context),
                    label: Text("Log in"),
                    icon: loginIcon,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
