import 'package:assignment_sem6/mainapp.dart';
import 'package:assignment_sem6/providers/authproviders.dart';
import 'package:assignment_sem6/providers/commentproviders.dart';
import 'package:assignment_sem6/providers/postproviders.dart';
import 'package:assignment_sem6/providers/themeprovider.dart';
import 'package:assignment_sem6/providers/userproviders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ...authProviders,
        ...userProviders,
        ...commentProviders,
        ...postProviders,
      ],
      child: const MainApp(),
    ),
  );
}
