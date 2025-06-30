import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/widgets/view/filter/fullscreenfilters.dart';
import 'package:assignment_sem6/screens/post/viewpost.dart';
import 'package:assignment_sem6/screens/view/map.dart';
import 'package:assignment_sem6/screens/view/timeline.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/util/role.dart';
import 'package:assignment_sem6/util/screen.dart';
import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:assignment_sem6/util/toast.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:assignment_sem6/widgets/sizedcircularprogressindicator.dart';
import 'package:assignment_sem6/widgets/view/filter/collapsiblefiltercontainer.dart';
import 'package:assignment_sem6/widgets/view/filter/filters.dart';
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
  late final TimelineController _timelineController;
  final ValueNotifier<ActiveView> _activeView = ValueNotifier(
    ActiveView.timeline,
  );
  late Filters _filters;
  bool _fullscreenFiltersOpen = false;
  bool _fetchingPosts = false;
  bool _showZoom = false;
  bool _isBigScreen = true;

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

  @override
  void initState() {
    super.initState();

    final startTimestamp = DateTime.now().subtract(const Duration(days: 1));
    final endTimestamp = DateTime.now();
    _timelineController = TimelineController.withTimeScale(
      items: {},
      startTimestamp: startTimestamp.millisecondsSinceEpoch,
      endTimestamp: endTimestamp.millisecondsSinceEpoch,
      timeScale: TimelineUtil.calculateInitialTimeScale(
        startTimestamp.millisecondsSinceEpoch,
        endTimestamp.millisecondsSinceEpoch,
      ),
    );

    _filters = Filters(
      searchQuery: "",
      startDate: startTimestamp,
      endDate: endTimestamp,
    );
    _filterUpdate(_filters);

    final postService = context.read<PostService>();
    postService.stream.listen((event) {
      _filterUpdate(_filters);
    });

    _timelineController.selectedItem.addListener(_onItemSelectedOnSmallScreen);
  }

  @override
  void dispose() {
    _timelineController.selectedItem.removeListener(
      _onItemSelectedOnSmallScreen,
    );
    _activeView.dispose();
    _timelineController.dispose();
    super.dispose();
  }

  void _onItemSelectedOnSmallScreen() {
    if (_isBigScreen) return;

    final selectedItem = _timelineController.selectedItem.value;
    if (selectedItem == null) return;

    final item = _timelineController.itemsMap[selectedItem];
    if (item == null) return;

    context.go("/post/${item.postUUID}", extra: item.color);
    _timelineController.selectedItem.value = null;
  }

  void _filterUpdate(Filters newFilters, {bool noResetPosition = false}) async {
    setState(() {
      _filters = newFilters;
      _fetchingPosts = true;
    });

    final postService = context.read<PostService>();
    final posts = await postService.getAll();

    if (_timelineController.startTimestamp !=
            _filters.startDate.millisecondsSinceEpoch ||
        _timelineController.endTimestamp !=
            _filters.endDate.millisecondsSinceEpoch) {
      _timelineController.updateTimestamps(
        _filters.startDate.millisecondsSinceEpoch,
        _filters.endDate.millisecondsSinceEpoch,
      );
      if (!noResetPosition) {
        _timelineController.reset();
      }
    }

    _arrangeElements(
      posts.where((post) => _filters.matches(post)),
      completelyNewView: !noResetPosition,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    setState(() {
      _fetchingPosts = false;
    });
  }

  void _expandLeft() {
    _timelineController.startTimestamp =
        _timelineController.startTimestamp -
        TimelineUtil.preferredExpansion(_timelineController.visibleTimeScale);
    _filters = _filters.copyWith(
      startDate: DateTime.fromMillisecondsSinceEpoch(
        _timelineController.startTimestamp,
      ),
    );
    _filterUpdate(_filters, noResetPosition: true);
  }

  void _expandRight() {
    _timelineController.endTimestamp =
        _timelineController.endTimestamp +
        TimelineUtil.preferredExpansion(_timelineController.visibleTimeScale);
    _filters = _filters.copyWith(
      endDate: DateTime.fromMillisecondsSinceEpoch(
        _timelineController.endTimestamp,
      ),
    );
    _filterUpdate(_filters, noResetPosition: true);
  }

  void _arrangeElements(
    Iterable<Post> posts, {
    bool completelyNewView = false,
  }) {
    final sorted = posts.toList();
    sorted.sort((a, b) => a.startTimestamp.compareTo(b.startTimestamp));

    final List<TimelineItem> arranged = [];

    for (int i = 0; i < sorted.length; i++) {
      final post = sorted[i];
      arranged.add(
        TimelineItem.fromPost(
          post,
          layer: TimelineUtil.resolveLayer(post.startTimestamp, arranged),
          color: Colors.primaries[i % Colors.primaries.length],
          layerOffset:
              _timelineController.items.isEmpty || completelyNewView
                  ? 0.0
                  : _timelineController.items[0].layerOffset,
        ),
      );
    }

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
    final screenUtil = ScreenUtil(context);

    if (_isBigScreen != screenUtil.isBigScreen) {
      _isBigScreen = screenUtil.isBigScreen;
      setState(() {});
    }

    return Screen(
      title: Text(_activeView.value.title),
      padding: EdgeInsets.zero,
      appBarActions: [
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
      child: Stack(
        children: [
          ListenableBuilder(
            listenable: _activeView,
            builder:
                (context, _) => Column(
                  children: [
                    if (_isBigScreen)
                      ListenableBuilder(
                        listenable: _timelineController.selectedItem,
                        builder: (context, _) {
                          if (_timelineController.selectedItem.value != null) {
                            final item =
                                _timelineController.itemsMap[_timelineController
                                    .selectedItem
                                    .value!];
                            if (item == null) return SizedBox.shrink();

                            return Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(100),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ViewPost(
                                  leading: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      _timelineController.selectedItem.value =
                                          null;
                                    },
                                  ),
                                  actions: [
                                    IconButton(
                                      icon: Icon(Icons.fullscreen),
                                      onPressed: () {
                                        context.go(
                                          "/post/${item.postUUID}",
                                          extra: item.color,
                                        );
                                      },
                                    ),
                                  ],
                                  key: ValueKey(item.key),
                                  postUUID: item.postUUID,
                                  backgroundColor: item.color,
                                ),
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
                                  expandLeft: _expandLeft,
                                  expandRight: _expandRight,
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
                              final screenWidth =
                                  MediaQuery.sizeOf(context).width;
                              final int fullLength =
                                  _timelineController.endTimestamp -
                                  _timelineController.startTimestamp;
                              final int visibleCenter =
                                  _timelineController.visibleCenterTimestamp;
                              final double fraction =
                                  (visibleCenter -
                                      _timelineController.startTimestamp) /
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
                            child:
                                _isBigScreen
                                    ? CollapsibleFilterContainer(
                                      filters: _filters,
                                      onFilterApplied: (newFilters) {
                                        _filterUpdate(newFilters);
                                      },
                                    )
                                    : IconButton.filled(
                                      onPressed: () {
                                        setState(() {
                                          _fullscreenFiltersOpen = true;
                                        });
                                      },
                                      icon: Icon(Icons.search),
                                    ),
                          ),
                        ],
                      ),
                    ),
                    ListenableBuilder(
                      listenable: Listenable.merge([
                        _timelineController,
                        _timelineController.selectedItem,
                      ]),
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
          if (_fullscreenFiltersOpen)
            Positioned.fill(
              child: FullscreenFilters(
                filters: _filters,
                onFilterApplied: (newFilters) {
                  _filterUpdate(newFilters);
                },
                close: () {
                  setState(() {
                    _fullscreenFiltersOpen = false;
                  });
                },
              ),
            ),
          if (_fetchingPosts)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(50),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 24.0,
                        children: [
                          Text(
                            "Refreshing posts...",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedCircularProgressIndicator.square(size: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
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
