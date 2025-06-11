import 'package:assignment_sem6/data/dao/impl/memorypostdao.dart';
import 'package:assignment_sem6/data/dao/impl/memoryuserdao.dart';
import 'package:assignment_sem6/data/dao/postdao.dart';
import 'package:assignment_sem6/data/dao/userdao.dart';
import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/repo/impl/postrepositoryimpl.dart';
import 'package:assignment_sem6/data/repo/impl/userrepositoryimpl.dart';
import 'package:assignment_sem6/data/repo/postrepository.dart';
import 'package:assignment_sem6/data/repo/userrepository.dart';
import 'package:assignment_sem6/data/service/impl/postserviceimpl.dart';
import 'package:assignment_sem6/data/service/impl/userserviceimpl.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/data/service/userservice.dart';
import 'package:assignment_sem6/screens/home.dart';
import 'package:assignment_sem6/screens/login.dart';
import 'package:assignment_sem6/screens/register.dart';
import 'package:assignment_sem6/screens/settings.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),

        Provider<UserDao>(
          create: (_) {
            final dao = MemoryUserDao();
            dao.init();
            return dao;
          },
        ),
        ProxyProvider<UserDao, UserRepository>(
          update: (_, dao, _) => UserRepositoryImpl(dao: dao),
        ),
        ProxyProvider<UserRepository, UserService>(
          update: (_, repository, _) => UserServiceImpl(repository: repository),
        ),
        StreamProvider<List<User>>(
          create: (context) => context.read<UserService>().stream,
          initialData: const [],
        ),

        Provider<PostDao>(
          create: (_) {
            final dao = MemoryPostDao();
            dao.init();
            return dao;
          },
        ),
        ProxyProvider<PostDao, PostRepository>(
          update: (_, dao, _) => PostRepositoryImpl(dao: dao),
        ),
        ProxyProvider<PostRepository, PostService>(
          update: (_, repository, _) => PostServiceImpl(repository: repository),
        ),
        StreamProvider<List<Post>>(
          create: (context) => context.read<PostService>().stream,
          initialData: const [],
        ),
      ],
      child: const MainApp(),
    ),
  );
}

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

    final authState = context.read<AuthState>();

    _router = GoRouter(
      initialLocation: "/login",
      refreshListenable: authState,
      redirect: (context, state) {
        final loggedIn = authState.isLoggedIn;
        final isLoggingIn =
            state.fullPath == "/login" || state.fullPath == "/register";

        if (!loggedIn) {
          return isLoggingIn ? null : "/login";
        }

        if (loggedIn && isLoggingIn) {
          return "/";
        }

        return null;
      },
      routes: [
        GoRoute(
          path: "/",
          name: HomePage.routeName,
          builder: (context, state) => const HomePage(),
          routes: [
            GoRoute(
              name: SettingsPage.routeName,
              path: SettingsPage.routeName,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
        GoRoute(
          name: LoginPage.routeName,
          path: "/${LoginPage.routeName}",
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          name: RegisterPage.routeName,
          path: "/${RegisterPage.routeName}",
          builder: (context, state) => const RegisterPage(),
        ),
      ],
    );
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
      builder: (context, child) {
        return Listener(onPointerDown: _onPointerDown, child: child);
      },
    );
  }
}
