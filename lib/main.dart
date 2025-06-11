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
import 'package:assignment_sem6/screens/settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
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
