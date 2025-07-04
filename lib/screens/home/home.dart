import 'dart:io';

import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/screens/home/createpostfab.dart';
import 'package:assignment_sem6/screens/home/fetchingoverlay.dart';
import 'package:assignment_sem6/screens/home/filtersortoggle.dart';
import 'package:assignment_sem6/screens/home/fullscreenfiltersdisplay.dart';
import 'package:assignment_sem6/screens/home/homeappbaritems.dart';
import 'package:assignment_sem6/screens/home/splitviewpost.dart';
import 'package:assignment_sem6/screens/home/timelinezoomoverlay.dart';
import 'package:assignment_sem6/screens/home/view/map.dart';
import 'package:assignment_sem6/screens/home/view/timeline.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/util/screen.dart';
import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:assignment_sem6/util/toast.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:assignment_sem6/widgets/view/filter/filters.dart';
import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimap.dart';
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
  bool _fetchingPosts = false;
  bool _showZoom = false;
  bool _isBigScreen = true;
  bool _fullscreenFiltersOpen = false;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      _focusNode.requestFocus();
    }
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

  final FocusNode _focusNode = FocusNode();

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (_timelineController.selectedItem.value != null) {
        _timelineController.selectedItem.value = null;
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
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
      appBarActions: homeAppBarItems(context, user, _logout),
      floatingActionButton: CreatePostFab(
        bottomOffset: _activeView.value.fabOffset,
        user: user,
      ),
      child: Focus(
        focusNode: _focusNode,
        onKeyEvent: _handleKeyEvent,
        child: Stack(
          children: [
            ListenableBuilder(
              listenable: _activeView,
              builder:
                  (context, _) => Column(
                    children: [
                      SplitViewPost(
                        selectedListenable: _timelineController.selectedItem,
                        getItem: (key) => _timelineController.itemsMap[key],
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Visibility(
                                visible:
                                    _activeView.value == ActiveView.timeline,
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
                                        () =>
                                            _setActiveView(ActiveView.timeline),
                                    activeView: _activeView,
                                  ),
                                ),
                              ),
                            ),
                            TimelineZoomOverlay(
                              timelineController: _timelineController,
                              showZoom: _showZoom,
                            ),
                            FiltersOrToggle(
                              filters: _filters,
                              filterUpdate: _filterUpdate,
                              openFullscreenFilters:
                                  () => setState(() {
                                    _fullscreenFiltersOpen = true;
                                  }),
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
            FullscreenFiltersDisplay(
              visible: _fullscreenFiltersOpen,
              filters: _filters,
              filterUpdate: _filterUpdate,
              close:
                  () => setState(() {
                    _fullscreenFiltersOpen = false;
                  }),
            ),
            FetchingOverlay(visible: _fetchingPosts),
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
