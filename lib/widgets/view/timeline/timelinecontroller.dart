import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/foundation.dart';

import 'timeline.dart';

typedef Range = ({int start, int end});

class TimelineController extends ChangeNotifier {
  Map<String, TimelineItem> _items;
  ValueNotifier<String?> selectedItem = ValueNotifier<String?>(null);
  int _startTimestamp;
  int _endTimestamp;

  int _visibleStartTimestamp;
  int _visibleEndTimestamp;

  double _verticalOffset = 0;

  bool _layerShiftMode = false;

  TimelineController({
    required Map<String, TimelineItem> items,
    required int startTimestamp,
    required int endTimestamp,
    required int visibleStartTimestamp,
    required int visibleEndTimestamp,
    required int initialTimeScale,
    int centerOffset = 0,
    int verticalOffset = 0,
    double zoom = 1.0,
  }) : _items = items,
       _startTimestamp = startTimestamp,
       _endTimestamp = endTimestamp,
       _visibleStartTimestamp = visibleStartTimestamp,
       _visibleEndTimestamp = visibleEndTimestamp;

  TimelineController.withTimeScale({
    required Map<String, TimelineItem> items,
    required int startTimestamp,
    required int endTimestamp,
    required int timeScale,
  }) : this(
         items: items,
         startTimestamp: startTimestamp,
         endTimestamp: endTimestamp,
         initialTimeScale: timeScale,
         visibleStartTimestamp:
             _applyTimeScale(
               (startTimestamp + endTimestamp) ~/ 2,
               timeScale,
             ).start,
         visibleEndTimestamp:
             _applyTimeScale(
               (startTimestamp + endTimestamp) ~/ 2,
               timeScale,
             ).end,
       );

  List<TimelineItem> get items => _items.values.toList();
  Map<String, TimelineItem> get itemsMap => _items;
  int get startTimestamp => _startTimestamp;
  int get endTimestamp => _endTimestamp;
  int get centerTimestamp => (_startTimestamp + _endTimestamp) ~/ 2;
  double get verticalOffset =>
      (_verticalOffset.abs() < 20 ? 0 : _verticalOffset) *
      (layerShiftMode ? 1.0 : -1.0);
  Range get range => (start: _startTimestamp, end: _endTimestamp);
  int get initialTimeScale =>
      TimelineUtil.calculateInitialTimeScale(_startTimestamp, _endTimestamp);

  int get visibleStartTimestamp => _visibleStartTimestamp;
  int get visibleEndTimestamp => _visibleEndTimestamp;
  int get visibleCenterTimestamp =>
      (_visibleStartTimestamp + _visibleEndTimestamp) ~/ 2;
  Range get visibleRange => (
    start: _visibleStartTimestamp,
    end: _visibleEndTimestamp,
  );

  int get visibleTimeScale => _visibleEndTimestamp - _visibleStartTimestamp;

  bool get layerShiftMode => _layerShiftMode;

  set layerShiftMode(bool value) {
    if (_layerShiftMode == value) return;
    _layerShiftMode = value;
    notifyListeners();
  }

  int getTickEvery(int totalWidth) =>
      TimelineUtil.calculateTickEvery(visibleTimeScale, totalWidth);

  set items(List<TimelineItem> newItems) {
    _items = {for (final item in newItems) item.key: item};
    selectedItem.value = null;
    notifyListeners();
  }

  set itemsMap(Map<String, TimelineItem> newItems) {
    _items = newItems;
    selectedItem.value = null;
    notifyListeners();
  }

  List<TimelineItem> getVisibleItems() {
    return items.where((item) {
      return item.endTimestamp >= visibleStartTimestamp &&
          item.startTimestamp <= visibleEndTimestamp;
    }).toList();
  }

  set startTimestamp(int newStart) {
    _startTimestamp = newStart;
    notifyListeners();
  }

  set endTimestamp(int newEnd) {
    _endTimestamp = newEnd;
    notifyListeners();
  }

  void updateItems(List<TimelineItem> newItems, {bool resetSelected = true}) {
    List<TimelineItem> sorted = List.from(newItems);

    if (_layerShiftMode) {
      sorted.sort(
        (a, b) => b.effectiveLayer.abs().compareTo(a.effectiveLayer.abs()),
      );
    } else {
      sorted.sort((a, b) => b.rawLayer.abs().compareTo(a.rawLayer.abs()));
    }

    _items = {for (final item in sorted) item.key: item};

    if (resetSelected) {
      selectedItem.value = null;
    }

    notifyListeners();
  }

  void updateTimestamps(int newStart, int newEnd) {
    startTimestamp = newStart;
    endTimestamp = newEnd;
    notifyListeners();
  }

  void updateVisibleRange(int newVisibleStart, int newVisibleEnd) {
    if (newVisibleStart < _startTimestamp) {
      final unable = _startTimestamp - newVisibleStart;
      newVisibleStart = _startTimestamp;
      newVisibleEnd += unable;

      if (newVisibleEnd > _endTimestamp) {
        newVisibleEnd = _endTimestamp;
      }
    } else if (newVisibleEnd > _endTimestamp) {
      final unable = newVisibleEnd - (_endTimestamp);
      newVisibleEnd = _endTimestamp;
      newVisibleStart -= unable;

      if (newVisibleStart < _startTimestamp) {
        newVisibleStart = _startTimestamp;
      }
    }

    _visibleStartTimestamp = newVisibleStart;
    _visibleEndTimestamp = newVisibleEnd;
    notifyListeners();
  }

  static Range _pan(Range old, int delta) {
    final newStart = old.start + delta;
    final newEnd = old.end + delta;
    return (start: newStart, end: newEnd);
  }

  void pan(int delta) {
    final newRange = _pan(visibleRange, delta);
    updateVisibleRange(newRange.start, newRange.end);
  }

  static Range _zoom(int center, Range old, double factor) {
    final difference = (old.end - old.start) ~/ 2;
    final newDifference = (difference / factor);
    final newStart = center - newDifference;
    final newEnd = center + newDifference;
    return (start: newStart.toInt(), end: newEnd.toInt());
  }

  void zoom(double factor) {
    final newRange = _zoom(visibleCenterTimestamp, visibleRange, factor);
    updateVisibleRange(newRange.start, newRange.end);
  }

  static Range _applyTimeScale(int center, int timeScale) {
    final newStart = center - timeScale ~/ 2;
    final newEnd = center + timeScale ~/ 2;
    return (start: newStart, end: newEnd);
  }

  void applyTimeScale(int timeScale) {
    final newRange = _applyTimeScale(centerTimestamp, timeScale);
    updateVisibleRange(newRange.start, newRange.end);
  }

  void adjustVisibleStart(int by) {
    final newStart = (_visibleStartTimestamp + by).toInt();

    if (newStart < startTimestamp) {
      _visibleStartTimestamp = startTimestamp;
      notifyListeners();
      return;
    }

    if (newStart > _visibleEndTimestamp) {
      _visibleStartTimestamp = _visibleEndTimestamp;
      notifyListeners();
      return;
    }

    _visibleStartTimestamp = newStart;
    notifyListeners();
  }

  void adjustVisibleEnd(int by) {
    final newEnd = (_visibleEndTimestamp + by).toInt();

    if (newEnd > endTimestamp) {
      _visibleEndTimestamp = startTimestamp;
      notifyListeners();
      return;
    }

    if (newEnd < _visibleStartTimestamp) {
      _visibleEndTimestamp = _visibleStartTimestamp;
      notifyListeners();
      return;
    }

    _visibleEndTimestamp = newEnd;
    notifyListeners();
  }

  void adjustVerticalOffset(int by) {
    if (by == 0) return;
    if (items.isEmpty) return;

    final height = Timeline.timelineItemHeight;

    final oldLayerOffset = TimelineUtil.calculateLayerOffset(
      _verticalOffset,
      height,
      2,
    );

    double verticalOffset = _verticalOffset + by;
    double layerOffset = TimelineUtil.calculateLayerOffset(
      verticalOffset,
      height,
      2,
    );
    if (layerOffset == oldLayerOffset) {
      _verticalOffset = verticalOffset;
      notifyListeners();
      return;
    }

    int maxLayer = 1;
    int minLayer = -1;
    for (final item in items) {
      if (item.rawLayer > 0) {
        if (item.rawLayer > maxLayer) {
          maxLayer = item.rawLayer;
        }
      } else {
        if (item.rawLayer < minLayer) {
          minLayer = item.rawLayer;
        }
      }
    }

    _verticalOffset = verticalOffset;

    List<TimelineItem> newItems = [];
    for (final item in items) {
      double offset = layerOffset;
      int direction = item.rawLayer < 0 ? 1 : -1;

      bool isOnZero = item.rawLayer + layerOffset == 0;
      if (isOnZero) {
        offset += direction * 0.5;
      }

      bool normallyOnHalf =
          (item.rawLayer + offset < 0 && item.rawLayer < 0) ||
          (item.rawLayer + offset > 0 && item.rawLayer > 0);

      if (!normallyOnHalf) {
        if (isOnZero) {
          offset += direction * 0.5;
        } else {
          offset += direction * 1.0;
        }
      }

      if (!normallyOnHalf && (item.rawLayer + offset).abs() == 0.5) {
        offset += direction * 1;
      }

      newItems.add(item.copyWith(layerOffset: offset));
    }

    updateItems(newItems, resetSelected: false);
  }

  void reset() {
    recenter();
    resetZoom();
    _verticalOffset = 0;
  }

  void recenter() {
    final center = (_startTimestamp + _endTimestamp) ~/ 2;
    final newRange = _applyTimeScale(center, visibleTimeScale);
    updateVisibleRange(newRange.start, newRange.end);
  }

  void resetZoom() {
    final center = visibleCenterTimestamp;
    final newRange = _applyTimeScale(center, initialTimeScale);
    updateVisibleRange(newRange.start, newRange.end);
  }
}
