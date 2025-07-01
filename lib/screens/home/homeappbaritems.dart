import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/util/role.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<PopupMenuButton> homeAppBarItems(
  BuildContext context,
  User? user,
  VoidCallback logout,
) => [
  PopupMenuButton(
    icon: Icon(Icons.person),
    menuPadding: EdgeInsets.only(top: 4),
    onSelected:
        (value) => {
          switch (value) {
            "profile" => context.go("/profile/${user!.uuid}"),
            "admin" => context.goNamed("admin"),
            "settings" => context.goNamed("settings"),
            "logout" => logout,
            _ => FlutterError("Unknown action selected: $value"),
          },
        },
    tooltip: "${user?.firstName} ${user?.lastName}",
    itemBuilder:
        (context) => <PopupMenuEntry>[
          PopupMenuItem<String>(
            value: "info",
            enabled: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 100),
              child: Text(
                'Hello, ${user?.firstName ?? "Guest"}!',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          PopupMenuDivider(),
          if (user != null)
            PopupMenuItem(value: "profile", child: Text("Profile")),
          if (user?.role == Role.administrator)
            PopupMenuItem(value: "admin", child: Text("Admin Panel")),
          PopupMenuItem(value: "settings", child: Text("Settings")),
          PopupMenuItem(value: "logout", child: Text("Log out")),
        ],
  ),
];
