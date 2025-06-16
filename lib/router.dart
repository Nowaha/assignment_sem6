import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/screens/home.dart';
import 'package:assignment_sem6/screens/login/login.dart';
import 'package:assignment_sem6/screens/login/register.dart';
import 'package:assignment_sem6/screens/post/createpost.dart';
import 'package:assignment_sem6/screens/post/viewpost.dart';
import 'package:assignment_sem6/screens/settings.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/util/time.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(AuthState authState) {
  redirectIfLoggedOut(context, state) {
    final loggedIn = authState.isLoggedIn;
    final isLoggingIn =
        state.fullPath == "/login" || state.fullPath == "/register";

    if (!loggedIn) return isLoggingIn ? null : "/login";

    final justLoggedIn = loggedIn && isLoggingIn;
    if (justLoggedIn) return "/";

    return null;
  }

  return GoRouter(
    initialLocation: "/login",
    refreshListenable: authState,
    redirect: redirectIfLoggedOut,
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
          GoRoute(name: "createPost", path: "post/create", builder: (context, state) {
            return CreatePost();
          }),
          GoRoute(
            path: "post/:postId",
            builder: (context, state) {
              final postId = state.pathParameters['postId'];
              
              if (postId == null) {
                return const Center(child: Text("Post ID is missing"));
              }

              return ViewPost(post: Post(uuid: postId, creationTimestamp: Time.nowAsTimestamp(), creatorUUID: "Creator ID!", title: "Post Title :3"));
            },
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
