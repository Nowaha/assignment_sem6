import 'package:assignment_sem6/mainapp.dart';
import 'package:assignment_sem6/providers/auth_providers.dart';
import 'package:assignment_sem6/providers/post_providers.dart';
import 'package:assignment_sem6/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [...authProviders, ...userProviders, ...postProviders],
      child: const MainApp(),
    ),
  );
}
