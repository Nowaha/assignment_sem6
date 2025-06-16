import 'package:assignment_sem6/router.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router;

  void _onPointerDown(PointerDownEvent event) {
    if (event.buttons == kBackMouseButton) {
      if (_router.canPop()) {
        _router.pop();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _router = createRouter(context.read<AuthState>());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Semester 6",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
      builder:
          (context, child) => FToastBuilder()(
            context,
            Listener(onPointerDown: _onPointerDown, child: child),
          ),
    );
  }
}
