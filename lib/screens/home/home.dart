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
import 'package:assignment_sem6/state/timelinestate.dart';
import 'package:assignment_sem6/util/screen.dart';
import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:assignment_sem6/util/toast.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:assignment_sem6/widgets/view/filter/filters.dart';
import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimap.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TimelineState _timelineState;
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

    _timelineState = context.read<TimelineState>();
    _filters = Filters(
      searchQuery: "",
      startDate: DateTime.fromMillisecondsSinceEpoch(
        _timelineState.startTimestamp,
      ),
      endDate: DateTime.fromMillisecondsSinceEpoch(_timelineState.endTimestamp),
    );
    _filterUpdate(_filters);

    final postService = context.read<PostService>();
    postService.stream.listen((event) {
      _filterUpdate(_filters);
    });

    _timelineState.selectedItem.addListener(_onItemSelectedOnSmallScreen);
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
    _focusNode.dispose();
    _activeView.dispose();

    _timelineState.selectedItem.removeListener(_onItemSelectedOnSmallScreen);

    super.dispose();
  }

  void _onItemSelectedOnSmallScreen() {
    if (_isBigScreen) return;

    final timelineState = context.read<TimelineState>();
    final selectedItem = timelineState.selectedItem.value;
    if (selectedItem == null) return;

    final item = timelineState.itemsMap[selectedItem];
    if (item == null) return;

    context.go("/post/${item.postUUID}", extra: item.color);
    timelineState.selectedItem.value = null;
  }

  void _filterUpdate(Filters newFilters, {bool noResetPosition = false}) async {
    setState(() {
      _filters = newFilters;
      _fetchingPosts = true;
    });

    final timelineState = context.read<TimelineState>();
    final postService = context.read<PostService>();
    final posts = await postService.getAll();

    if (timelineState.startTimestamp !=
            _filters.startDate.millisecondsSinceEpoch ||
        timelineState.endTimestamp != _filters.endDate.millisecondsSinceEpoch) {
      timelineState.updateTimestamps(
        _filters.startDate.millisecondsSinceEpoch,
        _filters.endDate.millisecondsSinceEpoch,
      );
      if (!noResetPosition) {
        timelineState.reset();
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
    final timelineState = context.read<TimelineState>();
    timelineState.startTimestamp =
        timelineState.startTimestamp -
        TimelineUtil.preferredExpansion(timelineState.visibleTimeScale);
    _filters = _filters.copyWith(
      startDate: DateTime.fromMillisecondsSinceEpoch(
        timelineState.startTimestamp,
      ),
    );
    _filterUpdate(_filters, noResetPosition: true);
  }

  void _expandRight() {
    final timelineState = context.read<TimelineState>();
    timelineState.endTimestamp =
        timelineState.endTimestamp +
        TimelineUtil.preferredExpansion(timelineState.visibleTimeScale);
    _filters = _filters.copyWith(
      endDate: DateTime.fromMillisecondsSinceEpoch(timelineState.endTimestamp),
    );
    _filterUpdate(_filters, noResetPosition: true);
  }

  void _arrangeElements(
    Iterable<Post> posts, {
    bool completelyNewView = false,
  }) {
    final timelineState = context.read<TimelineState>();
    final sorted = posts.toList();
    sorted.sort((a, b) => a.startTimestamp.compareTo(b.startTimestamp));

    final List<TimelineItem> arranged = [];

    for (int i = 0; i < sorted.length; i++) {
      final post = sorted[i];
      arranged.add(
        TimelineItem.fromPost(
          post,
          layer: TimelineUtil.resolveLayer(post.startTimestamp, arranged),
          color: TimelineUtil.resolveColor(post),
          layerOffset:
              timelineState.items.isEmpty || completelyNewView
                  ? 0.0
                  : timelineState.items[0].layerOffset,
        ),
      );
    }

    timelineState.updateItems(arranged);
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
    final timelineState = context.read<TimelineState>();
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (timelineState.selectedItem.value != null) {
        timelineState.selectedItem.value = null;
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

    final timelineState = context.read<TimelineState>();

    if (_isBigScreen != screenUtil.isBigScreen) {
      _isBigScreen = screenUtil.isBigScreen;
      setState(() {});
    }

    return Screen(
      title: Text(_activeView.value.title),
      padding: EdgeInsets.zero,
      appBarActions: homeAppBarItems(context, user, _logout),
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
                        selectedListenable: timelineState.selectedItem,
                        getItem: (key) => timelineState.itemsMap[key],
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
                                    onTimelineButtonPressed:
                                        () =>
                                            _setActiveView(ActiveView.timeline),
                                    activeView: _activeView,
                                  ),
                                ),
                              ),
                            ),
                            TimelineZoomOverlay(showZoom: _showZoom),
                            FiltersOrToggle(
                              filters: _filters,
                              filterUpdate: _filterUpdate,
                              openFullscreenFilters:
                                  () => setState(() {
                                    _fullscreenFiltersOpen = true;
                                  }),
                            ),
                            CreatePostFab(user: user),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TimelineMiniMap(setShowZoom: _setShowZoom),
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
  timeline("Timeline View"),
  map("Map View");

  final String title;

  const ActiveView(this.title);
}
