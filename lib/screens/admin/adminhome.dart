import 'package:assignment_sem6/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminHomePage extends StatelessWidget {
  static const String routeName = "admin";

  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) => Screen.scroll(
    title: Text("Admin Panel"),
    alignment: Alignment.topLeft,
    child: Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "User Management",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Row(
          spacing: 10,
          children: [
            FilledButton(
              onPressed: () {
                context.go("/admin/users");
              },
              child: Text("View user list"),
            ),
            FilledButton(onPressed: () {}, child: Text("Create new user")),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "Group Management",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Row(
          spacing: 10,
          children: [
            FilledButton(
              onPressed: () {
                context.go("/admin/groups");
              },
              child: Text("View group list"),
            ),
            FilledButton(onPressed: () {}, child: Text("Create new group")),
          ],
        ),
      ],
    ),
  );
}
