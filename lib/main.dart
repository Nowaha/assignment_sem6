import 'package:assignment_sem6/screens/home.dart';
import 'package:assignment_sem6/screens/settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MainApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: HomePage.routeName,
      builder: (context, state) {
        return const HomePage();
      },
      routes: [
        GoRoute(
          path: SettingsPage.routeName,
          builder: (context, state) {
            return const SettingsPage();
          },
        ),
      ],
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  void onPointerDown(PointerDownEvent event) {
    if (event.buttons == kBackMouseButton) {
      if (_router.canPop()) {
        _router.pop();
      }
    } /* else if (event.buttons == kForwardMouseButton) {
      
    } */
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Semester 6',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
      builder: (context, child) {
        return Listener(onPointerDown: onPointerDown, child: child);
      },
    );
  }
}
