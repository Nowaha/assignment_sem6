import 'package:assignment_sem6/mixin/toastmixin.dart';
import 'package:assignment_sem6/screens/view/map.dart';
import 'package:assignment_sem6/screens/view/timeline.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ToastMixin {
  ActiveView activeView = ActiveView.timeline;

  void _setActiveView(ActiveView view) {
    if (activeView == view) return;
    setState(() {
      activeView = view;
    });
  }

  void _logout() {
    showToast("You have been logged out.");
    context.read<AuthState>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final user = authState.getCurrentUser;

    return Screen(
      title: Text(activeView.title),
      padding: EdgeInsets.zero,
      appBarActions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
        PopupMenuButton(
          icon: Icon(Icons.person),
          menuPadding: EdgeInsets.only(top: 4),
          onSelected:
              (value) => {
                switch (value) {
                  "profile" => context.go("/profile/${user!.uuid}"),
                  "settings" => context.goNamed("settings"),
                  "logout" => _logout(),
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
                PopupMenuItem(value: "settings", child: Text("Settings")),
                PopupMenuItem(value: "logout", child: Text("Log out")),
              ],
        ),
      ],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (user == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("You must be logged in to post.")),
            );
            return;
          }

          context.goNamed("createPost");
        },
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Visibility(
              visible: activeView == ActiveView.timeline,
              maintainState: true,
              child: TimelineView(
                onMapButtonPressed: () => _setActiveView(ActiveView.map),
              ),
            ),
          ),
          Positioned.fill(
            child: Visibility(
              visible: activeView == ActiveView.map,
              maintainState: true,
              child: MapView(
                onTimelineButtonPressed:
                    () => _setActiveView(ActiveView.timeline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum ActiveView {
  timeline("Timeline View"),
  map("Map View");

  final String title;

  const ActiveView(this.title);
}
