import 'package:assignment_sem6/screens/home/home.dart';
import 'package:assignment_sem6/widgets/view/map/basemap.dart';
import 'package:flutter/material.dart';

class HomeMap extends BaseMapWidget {
  final ValueNotifier<ActiveView>? activeView;

  const HomeMap({
    super.key,
    super.initialCenter,
    super.initialZoom,
    this.activeView,
  });

  @override
  State<StatefulWidget> createState() => _HomeMapState();
}

class _HomeMapState extends BaseMapState<HomeMap> {
  @override
  void initState() {
    widget.activeView?.addListener(_onActiveViewChanged);
    super.initState();
  }

  @override
  void filter() {
    if (widget.activeView != null &&
        widget.activeView!.value != ActiveView.map) {
      return;
    }

    super.filter();
  }

  void _onActiveViewChanged() {
    final newView = widget.activeView?.value;
    if (newView == ActiveView.map) {
      filter();
    } else {
      setState(() {
        filtered.clear();
      });
    }
  }
}
