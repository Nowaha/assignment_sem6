import 'package:assignment_sem6/screens/login.dart';
import 'package:assignment_sem6/widgets/sizedcircularprogressindicator.dart';
import 'package:assignment_sem6/widgets/textinput.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = "register";

  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? _error;
  bool _loading = false;

  final usernameEmailController = TextEditingController();
  final passwordController = TextEditingController();

  void _attemptToAuthenticate() async {
    if (_loading) return;
    _loading = true;

    setState(() {
      _error = null;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _loading = false;
      _error = "Invalid username or password, please try again.";
    });
  }

  void _clearError() {
    if (_error == null) return;

    setState(() {
      _error = null;
    });
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
              Text("Register", style: theme.textTheme.headlineLarge),
              Text(
                "Create a new account by entering your details in the fields below.",
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
                            ? () => context.goNamed(LoginPage.routeName)
                            : null,
                    child: Text("Log in"),
                  ),
                  FilledButton.icon(
                    onPressed: _attemptToAuthenticate,
                    label: Text("Register"),
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
