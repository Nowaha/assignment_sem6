import 'package:assignment_sem6/screens/admin/adminhome.dart';
import 'package:assignment_sem6/screens/admin/group/grouplist.dart';
import 'package:assignment_sem6/screens/admin/user/userlist.dart';
import 'package:assignment_sem6/screens/home.dart';
import 'package:assignment_sem6/screens/login/login.dart';
import 'package:assignment_sem6/screens/login/register.dart';
import 'package:assignment_sem6/screens/post/createpost.dart';
import 'package:assignment_sem6/screens/post/viewpost.dart';
import 'package:assignment_sem6/screens/profile/profile.dart';
import 'package:assignment_sem6/screens/settings.dart';
import 'package:assignment_sem6/state/authstate.dart';
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
          GoRoute(
            name: AdminHomePage.routeName,
            path: AdminHomePage.routeName,
            builder: (context, state) => const AdminHomePage(),
            routes: [
              GoRoute(
                path: "users",
                builder: (context, state) => const UserListPage(),
              ),
              GoRoute(
                path: "groups",
                builder: (context, state) => const GroupListPage(),
              ),
            ],
          ),
          GoRoute(
            name: "createPost",
            path: "post/create",
            builder: (context, state) {
              return CreatePost();
            },
          ),
          GoRoute(
            path: "post/:postUUID",
            builder: (context, state) {
              final postUUID = state.pathParameters['postUUID'];

              if (postUUID == null) {
                return const Center(child: Text("Post UUID is missing"));
              }

              return ViewPost(postUUID: postUUID);
            },
          ),
          GoRoute(
            path: "profile/:userUUID",
            builder: (context, state) {
              final userUUID = state.pathParameters['userUUID'];

              if (userUUID == null) {
                return const Center(child: Text("User UUID is missing"));
              }

              return Profile(userUUID: userUUID);
            },
          ),
        ],
      ),
      GoRoute(
        name: LoginPage.routeName,
        path: "/${LoginPage.routeName}",
        pageBuilder:
            (context, state) =>
                NoTransitionPage(key: state.pageKey, child: const LoginPage()),
      ),
      GoRoute(
        name: RegisterPage.routeName,
        path: "/${RegisterPage.routeName}",
        pageBuilder:
            (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const RegisterPage(),
            ),
      ),
    ],
  );
}
