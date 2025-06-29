import 'dart:math';

import 'package:assignment_sem6/screens/post/viewpost.dart';
import 'package:assignment_sem6/screens/view/map.dart';
import 'package:assignment_sem6/screens/view/timeline.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/util/role.dart';
import 'package:assignment_sem6/util/time.dart';
import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:assignment_sem6/util/toast.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:assignment_sem6/widgets/view/filter/filtercontainer.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/basictimelineitem.dart';
import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimap.dart';
import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimapzoom.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<TempPost> _posts;
  late final TimelineController _timelineController;
  final ValueNotifier<ActiveView> _activeView = ValueNotifier(
    ActiveView.timeline,
  );
  bool _showZoom = false;

  double visibleStart = -1;
  double visibleEnd = -1;

  void _setShowZoom(bool show) {
    if (_showZoom == show) return;

    if (show) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }

    setState(() {
      _showZoom = show;
    });
  }

  LatLng generateLocation(Random random) => LatLng(
    41.8719 + random.nextDouble() * 0.5 - 0.05,
    12.5674 + random.nextDouble() * 0.5 - 0.05,
  );

  @override
  void initState() {
    final startTimestamp =
        (Time.nowAsTimestamp() ~/ 1000 * 1000) -
        (1000 * 60 * 60 * 24 * 2); // 2 days ago
    final secondDay = startTimestamp + (1000 * 60 * 60 * 24); // 24 hours later
    final endTimestamp =
        startTimestamp + (1000 * 60 * 60 * 24 * 2).toInt(); // 2 days later
    _timelineController = TimelineController.withTimeScale(
      items: [],
      startTimestamp: startTimestamp,
      endTimestamp: endTimestamp,
      timeScale: 1000 * 60 * 30, // half an hour
    );

    final random = Random();
    _posts = [
      TempPost(
        startTimestamp: secondDay,
        endTimestamp: secondDay + (1000 * 60 * 10),
        name: "Post 1",
        color: Colors.red,
        location: generateLocation(random),
      ),
      TempPost(
        startTimestamp: secondDay + (1000 * 60 * 10),
        endTimestamp: secondDay + (1000 * 60 * 15),
        name: "Post 2",
        color: Colors.blue,
        location: generateLocation(random),
      ),
      TempPost(
        startTimestamp: secondDay + (1000 * 60 * 10),
        endTimestamp: secondDay + (1000 * 60 * 20),
        name: "Post 3",
        color: Colors.green,
        location: generateLocation(random),
      ),
      TempPost(
        startTimestamp: secondDay + (1000 * 60 * 23),
        endTimestamp: secondDay + (1000 * 60 * 50),
        name: "Post 4",
        color: Colors.orange,
        location: generateLocation(random),
      ),
      TempPost(
        startTimestamp: secondDay + (1000 * 60 * 25),
        endTimestamp: secondDay + (1000 * 60 * 40),
        name: "Post 5",
        color: Colors.purple,
        location: generateLocation(random),
      ),
      TempPost(
        startTimestamp: secondDay + (1000 * 60 * 27),
        endTimestamp: secondDay + (1000 * 60 * 43),
        name: "Post 7",
        color: Colors.deepOrange,
        location: generateLocation(random),
      ),
      TempPost(
        startTimestamp: secondDay + (1000 * 60 * 50),
        endTimestamp: secondDay + (1000 * 60 * 60),
        name: "Post 6",
        color: Colors.yellow,
        location: generateLocation(random),
      ),
      // for (int i = 0; i < 10; i++)
      //   TempPost(
      //     startTimestamp: secondDay + (1000 * 60 * 50) + (1000 * i),
      //     endTimestamp: secondDay + (1000 * 60 * 50) + 1000 * (i + 1),
      //     name: "Post small",
      //     color: Colors.primaries[i],
      //     location: generateLocation(random),
      //   ),
      for (int i = startTimestamp; i < endTimestamp; i += 1000 * 60 * 30)
        TempPost(
          startTimestamp: i.toInt(),
          endTimestamp:
              i.toInt() + (1000 * 60 * (15 + (5 * random.nextInt(10)))),
          name: "Post ${(i - startTimestamp) ~/ (1000 * 60 * 30)}",
          color:
              Colors.primaries[(i ~/ (1000 * 60 * 30)) %
                  Colors.primaries.length],
          location: generateLocation(random),
        ),
    ];
    arrangeElements(_posts);

    // _timelineController.addListener(() {
    //   if (visibleStart != _timelineController.visibleStartTimestamp ||
    //       visibleEnd != _timelineController.visibleEndTimestamp) {
    //     visibleStart = _timelineController.visibleStartTimestamp.toDouble();
    //     visibleEnd = _timelineController.visibleEndTimestamp.toDouble();
    //     arrangeElements(_posts);
    //   }
    // });

    super.initState();
  }

  void arrangeElements(List<TempPost> posts) {
    final sorted = posts;
    sorted.sort((a, b) => a.startTimestamp.compareTo(b.startTimestamp));

    final List<TimelineItem> arranged = [];

    for (int i = 0; i < sorted.length; i++) {
      final post = sorted[i];

      int layer = TimelineUtil.resolveLayer(post.startTimestamp, arranged);

      arranged.add(
        BasicTimelineItem(
          startTimestamp: post.startTimestamp,
          endTimestamp: post.endTimestamp,
          name: post.name,
          rawLayer: layer,
          layerOffset: 0.0,
          color: post.color,
          location: post.location,
        ),
      );
    }

    // final int minVisualWidth = _timelineController.visibleTimeScale ~/ 50;
    // final grouped = groupSmallItems(
    //   arranged,
    //   minWidth: minVisualWidth.toDouble(),
    // );

    _timelineController.updateItems(arranged);
  }

  // List<TimelineItem> groupSmallItems(
  //   List<TimelineItem> items, {
  //   double minWidth = 4.0,
  // }) {
  //   final List<TimelineItem> result = [];
  //   final List<TimelineItem> groupedItems = [];

  //   for (int i = 0; i < items.length; i++) {
  //     final item = items[i];

  //     if (item.endTimestamp - item.startTimestamp < minWidth) {
  //       groupedItems.add(
  //         item.copyWith(
  //           rawLayer: TimelineUtil.resolveLayer(item.startTimestamp, result),
  //         ),
  //       );
  //     } else {
  //       if (groupedItems.isNotEmpty) {
  //         if (groupedItems.length > 1) {
  //           int count = groupedItems.fold(
  //             0,
  //             (total, item) => total + item.count,
  //           );
  //           final group = TimelineItemGroup(
  //             name: "$count Grouped Items",
  //             color: Colors.grey,
  //             items: groupedItems,
  //             rawLayer: 0,
  //           );
  //           result.add(
  //             group.copyWith(
  //               rawLayer: TimelineUtil.resolveLayer(
  //                 group.startTimestamp,
  //                 result,
  //               ),
  //             ),
  //           );
  //         } else {
  //           result.addAll(groupedItems);
  //         }
  //       }

  //       groupedItems.clear();
  //       result.add(
  //         item.copyWith(
  //           rawLayer: TimelineUtil.resolveLayer(item.startTimestamp, result),
  //         ),
  //       );
  //     }
  //   }

  //   return result;
  // }

  void _setActiveView(ActiveView view) {
    if (_activeView.value == view) return;
    HapticFeedback.lightImpact();
    _activeView.value = view;
  }

  void _logout() {
    Toast.showToast(context, "You have been logged out.");
    context.read<AuthState>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final user = authState.getCurrentUser;

    return Screen(
      title: Text(_activeView.value.title),
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
                  "admin" => context.goNamed("admin"),
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
                if (user?.role == Role.administrator)
                  PopupMenuItem(value: "admin", child: Text("Admin Panel")),
                PopupMenuItem(value: "settings", child: Text("Settings")),
                PopupMenuItem(value: "logout", child: Text("Log out")),
              ],
        ),
      ],
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: _activeView.value.fabOffset),
        child: FloatingActionButton(
          tooltip: "Create Post",
          onPressed: () {
            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("You must be logged in to post.")),
              );
              return;
            }

            context.goNamed("createPost");
          },
          child: Icon(Icons.add),
        ),
      ),
      child: ListenableBuilder(
        listenable: _activeView,
        builder:
            (context, _) => Column(
              children: [
                ListenableBuilder(
                  listenable: _timelineController.selectedItem,
                  builder: (context, _) {
                    if (_timelineController.selectedItem.value != null) {
                      return Expanded(
                        child: ViewPost(
                          key: ValueKey(
                            _timelineController
                                .selectedItem
                                .value!
                                .startTimestamp,
                          ),
                          postName:
                              _timelineController.selectedItem.value!.name,
                          backgroundColor:
                              _timelineController.selectedItem.value!.color,
                        ),
                      );
                    }

                    return SizedBox.shrink();
                  },
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Visibility(
                          visible: _activeView.value == ActiveView.timeline,
                          maintainState: true,
                          child: RepaintBoundary(
                            child: TimelineView(
                              controller: _timelineController,
                              onMapButtonPressed:
                                  () => _setActiveView(ActiveView.map),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Visibility(
                          visible: _activeView.value == ActiveView.map,
                          maintainState: true,
                          child: RepaintBoundary(
                            child: MapView(
                              controller: _timelineController,
                              onTimelineButtonPressed:
                                  () => _setActiveView(ActiveView.timeline),
                              activeView: _activeView,
                            ),
                          ),
                        ),
                      ),
                      ListenableBuilder(
                        listenable: _timelineController,
                        builder: (context, _) {
                          const double width = 400.0;
                          final screenWidth = MediaQuery.sizeOf(context).width;
                          final int fullLength =
                              _timelineController.effectiveEndTimestamp -
                              _timelineController.effectiveStartTimestamp;
                          final int visibleCenter =
                              _timelineController.visibleCenterTimestamp;
                          final double fraction =
                              (visibleCenter -
                                  _timelineController.effectiveStartTimestamp) /
                              fullLength;
                          final double left =
                              fraction * screenWidth - 0.5 * width;
                          final bool tooSmall = screenWidth - width <= 0.0;
                          final double clamped =
                              tooSmall
                                  ? 0.0
                                  : left.clamp(0.0, screenWidth - width);

                          return Positioned(
                            bottom: 0,
                            left: tooSmall ? 16.0 : clamped,
                            right: tooSmall ? 16.0 : null,
                            child: TimelineMinimapZoom(
                              width: width,
                              fullWidth: screenWidth,
                              height: 90,
                              controller: _timelineController,
                              visible: _showZoom,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        left: 16,
                        top: 16,
                        child: RepaintBoundary(child: FilterContainer()),
                      ),
                    ],
                  ),
                ),
                ListenableBuilder(
                  listenable: _timelineController,
                  builder:
                      (context, _) => SizedBox(
                        width: double.infinity,
                        child: TimelineMiniMap(
                          controller: _timelineController,
                          setShowZoom: _setShowZoom,
                        ),
                      ),
                ),
              ],
            ),
      ),
    );
  }
}

enum ActiveView {
  timeline("Timeline View", 150.0),
  map("Map View", 150.0);

  final String title;
  final double fabOffset;

  const ActiveView(this.title, this.fabOffset);
}

class TempPost {
  final int startTimestamp;
  final int endTimestamp;
  final String name;
  final Color color;
  final LatLng location;

  const TempPost({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.name,
    this.color = Colors.purple,
    required this.location,
  });
}
