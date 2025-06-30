import 'dart:math';

import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/service/userservice.dart';
import 'package:assignment_sem6/mixin/formmixin.dart';
import 'package:assignment_sem6/screens/login/register.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/widgets/loadingiconbutton.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "login";

  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with FormMixin {
  final usernameEmailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // _TEMPLOGIN();
  }

  // void _TEMPLOGIN() async {
  //   final authState = context.read<AuthState>();
  //   final userService = context.read<UserService>();

  //   await Future.delayed(Duration(milliseconds: 100));

  //   authState.login(
  //     (await userService.authenticateByUsername("Admin", "123456"))!,
  //   );
  // }

  void _attemptToAuthenticate(BuildContext context) async {
    if (loading) return;
    setLoading(true);
    clearAllErrors();

    if (!validate()) {
      setLoading(false);
      return;
    }

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
        setState(() {
          setLoading(false, updateState: false);
          clearAllErrors();
        });
        authState.login(authenticatedUser);
        return;
      }

      setState(() {
        setLoading(false, updateState: false);
        setError(usernameEmailController, "Invalid username or password.");
      });
    } catch (error) {
      setState(() {
        setLoading(false, updateState: false);
        setError(
          usernameEmailController,
          "An error occured, please try again.",
        );
        print("Error during authentication: $error");
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    usernameEmailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screen.scroll(
      title: const Text("Semester 6"),
      child: SizedBox(
        width: 360,
        child: Column(
          spacing: 16,
          children: [
            Text("Log in", style: Theme.of(context).textTheme.headlineLarge),
            Text(
              "Please enter your username/email address and password to log in to your personal account.",
            ),

            buildFormTextInput(
              "Username/ Email Address",
              usernameEmailController,
              autoFocus: true,
            ),
            buildFormTextInput(
              "Password",
              passwordController,
              obscure: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _attemptToAuthenticate(context),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed:
                      !loading
                          ? () => context.goNamed(RegisterPage.routeName)
                          : null,
                  child: Text("Register"),
                ),
                LoadingIconButton(
                  label: "Log in",
                  loading: loading,
                  icon: Icon(Icons.login),
                  onPressed: () => _attemptToAuthenticate(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
