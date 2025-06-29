import 'package:assignment_sem6/data/dao/commentdao.dart';
import 'package:assignment_sem6/data/dao/postdao.dart';
import 'package:assignment_sem6/data/dao/userdao.dart';
import 'package:assignment_sem6/data/populator.dart';
import 'package:assignment_sem6/data/service/groupservice.dart';
import 'package:assignment_sem6/providers/themeprovider.dart';
import 'package:assignment_sem6/router.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

    _populateIfDebugAndEmpty();
  }

  void _populateIfDebugAndEmpty() async {
    if (const bool.fromEnvironment("dart.vm.product")) return;

    final postDao = context.read<PostDao>();
    if ((await postDao.findAll()).isNotEmpty) return;
    if (!mounted) return;

    Populator(
      userDao: context.read<UserDao>(),
      groupService: context.read<GroupService>(),
      postDao: postDao,
      commentDao: context.read<CommentDao>(),
    ).populate();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return MaterialApp.router(
      title: "Semester 6",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(centerTitle: false),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarTheme(centerTitle: false),
      ),
      themeMode: theme.themeMode,
      routerConfig: _router,
      builder:
          (context, child) =>
              Listener(onPointerDown: _onPointerDown, child: child),
    );
  }
}
