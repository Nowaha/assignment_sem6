import 'package:assignment_sem6/mixin/toastmixin.dart';
import 'package:assignment_sem6/screens/view/map.dart';
import 'package:assignment_sem6/screens/view/timeline.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/util/time.dart';
import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimap.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineitem.dart';
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
  late final TimelineController _timelineController;
  ActiveView activeView = ActiveView.timeline;

  @override
  void initState() {
    final startTimestamp = Time.nowAsTimestamp() ~/ 1000 * 1000;

    _timelineController = TimelineController.withTimeScale(
      items: [],
      startTimestamp: startTimestamp,
      endTimestamp: startTimestamp + (1000 * 60 * 60), // 1 hour
      timeScale: 1000 * 60 * 30, // half an hour
    );

    arrangeElements([
      TempPost(
        startTimestamp: startTimestamp,
        endTimestamp: startTimestamp + (1000 * 60 * 10),
        name: "Post 1",
        color: Colors.red,
      ),
      TempPost(
        startTimestamp: startTimestamp + (1000 * 60 * 10),
        endTimestamp: startTimestamp + (1000 * 60 * 20),
        name: "Post 2",
        color: Colors.blue,
      ),
      TempPost(
        startTimestamp: startTimestamp + (1000 * 60 * 15),
        endTimestamp: startTimestamp + (1000 * 60 * 30),
        name: "Post 3",
        color: Colors.green,
      ),
      TempPost(
        startTimestamp: startTimestamp + (1000 * 60 * 23),
        endTimestamp: startTimestamp + (1000 * 60 * 50),
        name: "Post 4",
        color: Colors.orange,
      ),
      TempPost(
        startTimestamp: startTimestamp + (1000 * 60 * 25),
        endTimestamp: startTimestamp + (1000 * 60 * 40),
        name: "Post 5",
        color: Colors.purple,
      ),
      TempPost(
        startTimestamp: startTimestamp + (1000 * 60 * 27),
        endTimestamp: startTimestamp + (1000 * 60 * 43),
        name: "Post 7",
        color: Colors.deepOrange,
      ),
      TempPost(
        startTimestamp: startTimestamp + (1000 * 60 * 50),
        endTimestamp: startTimestamp + (1000 * 60 * 60),
        name: "Post 6",
        color: Colors.yellow,
      ),
      for (int i = 7; i < 20; i++)
        TempPost(
          startTimestamp: startTimestamp + (1000 * 30 * (i - 1)),
          endTimestamp: startTimestamp + (1000 * 30 * (i + 3)),
          name: "Post $i",
          color: Colors.primaries[i % Colors.primaries.length],
        ),
      for (int i = 7; i < 20; i++)
        TempPost(
          startTimestamp: startTimestamp + (1000 * 30 * (i - 1)),
          endTimestamp: startTimestamp + (1000 * 30 * (i + 3)),
          name: "Post $i",
          color: Colors.primaries[i % Colors.primaries.length],
        ),
    ]);

    super.initState();
  }

  void arrangeElements(List<TempPost> posts) {
    final sorted = posts;
    sorted.sort((a, b) => a.startTimestamp.compareTo(b.startTimestamp));

    final List<TimelineItem> arranged = [];

    for (int i = 0; i < sorted.length; i++) {
      final post = sorted[i];

      int layer = TimelineUtil.resolveLayer(post, arranged);

      arranged.add(
        TimelineItem(
          startTimestamp: post.startTimestamp,
          endTimestamp: post.endTimestamp,
          name: post.name,
          height: 80.0,
          width: 300.0,
          layer: layer,
          color: post.color,
        ),
      );
    }

    _timelineController.updateItems(arranged);
  }

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
              child: RepaintBoundary(
                child: TimelineView(
                  controller: _timelineController,
                  onMapButtonPressed: () => _setActiveView(ActiveView.map),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Visibility(
              visible: activeView == ActiveView.map,
              maintainState: true,
              child: RepaintBoundary(
                child: MapView(
                  onTimelineButtonPressed:
                      () => _setActiveView(ActiveView.timeline),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: TimelineMiniMap(controller: _timelineController),
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

class TempPost {
  final int startTimestamp;
  final int endTimestamp;
  final String name;
  final Color color;

  const TempPost({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.name,
    this.color = Colors.purple,
  });
}
