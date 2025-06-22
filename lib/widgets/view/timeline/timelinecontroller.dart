import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineitem.dart';
import 'package:flutter/material.dart';

typedef Range = ({int start, int end});

class TimelineController extends ChangeNotifier {
  List<TimelineItem> _items;
  int _startTimestamp;
  int _endTimestamp;

  int _visibleStartTimestamp;
  int _visibleEndTimestamp;

  int _initialTimeScale;

  TimelineController({
    required List<TimelineItem> items,
    required int startTimestamp,
    required int endTimestamp,
    required int visibleStartTimestamp,
    required int visibleEndTimestamp,
    required int initialTimeScale,
    int centerOffset = 0,
    double zoom = 1.0,
  }) : _items = items,
       _startTimestamp = startTimestamp,
       _endTimestamp = endTimestamp,
       _initialTimeScale = initialTimeScale,
       _visibleStartTimestamp = visibleStartTimestamp,
       _visibleEndTimestamp = visibleEndTimestamp;

  TimelineController.withTimeScale({
    required List<TimelineItem> items,
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

  List<TimelineItem> get items => _items;
  int get startTimestamp => _startTimestamp;
  int get endTimestamp => _endTimestamp;
  int get centerTimestamp => (_startTimestamp + _endTimestamp) ~/ 2;
  Range get range => (start: _startTimestamp, end: _endTimestamp);

  int get effectiveStartTimestamp => _startTimestamp - leeway;
  int get effectiveEndTimestamp => _endTimestamp + leeway;

  int get visibleStartTimestamp => _visibleStartTimestamp;
  int get visibleEndTimestamp => _visibleEndTimestamp;
  int get visibleCenterTimestamp =>
      (_visibleStartTimestamp + _visibleEndTimestamp) ~/ 2;
  Range get visibleRange => (
    start: _visibleStartTimestamp,
    end: _visibleEndTimestamp,
  );

  int get visibleTimeScale => _visibleEndTimestamp - _visibleStartTimestamp;

  int get leeway => (_endTimestamp - _startTimestamp) ~/ 100;

  int getTickEvery(int totalWidth) =>
      TimelineUtil.calculateTickEvery(visibleTimeScale, totalWidth);

  set items(List<TimelineItem> newItems) {
    _items = newItems;
    notifyListeners();
  }

  set startTimestamp(int newStart) {
    _startTimestamp = newStart;
    notifyListeners();
  }

  set endTimestamp(int newEnd) {
    _endTimestamp = newEnd;
    notifyListeners();
  }

  void updateItems(List<TimelineItem> newItems) {
    items = newItems;
    items.sort((a, b) => b.layer.compareTo(a.layer));
    notifyListeners();
  }

  void updateTimestamps(int newStart, int newEnd) {
    startTimestamp = newStart;
    endTimestamp = newEnd;
    notifyListeners();
  }

  void updateVisibleRange(int newVisibleStart, int newVisibleEnd) {
    if (newVisibleStart < _startTimestamp - leeway) {
      final unable = _startTimestamp - leeway - newVisibleStart;
      newVisibleStart = _startTimestamp - leeway;
      newVisibleEnd += unable;

      if (newVisibleEnd > _endTimestamp + leeway) {
        newVisibleEnd = _endTimestamp + leeway;
      }
    } else if (newVisibleEnd > _endTimestamp + leeway) {
      final unable = newVisibleEnd - (_endTimestamp + leeway);
      newVisibleEnd = _endTimestamp + leeway;
      newVisibleStart -= unable;

      if (newVisibleStart < _startTimestamp - leeway) {
        newVisibleStart = _startTimestamp - leeway;
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
    final newDifference = (difference / factor).toInt();
    final newStart = center - newDifference;
    final newEnd = center + newDifference;
    return (start: newStart, end: newEnd);
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

    if (newStart < effectiveStartTimestamp) {
      _visibleStartTimestamp = effectiveStartTimestamp;
      notifyListeners();
      return;
    }

    if (newStart > _visibleEndTimestamp - leeway) {
      _visibleStartTimestamp = _visibleEndTimestamp - leeway;
      notifyListeners();
      return;
    }

    _visibleStartTimestamp = newStart;
    notifyListeners();
  }

  void adjustVisibleEnd(int by) {
    final newEnd = (_visibleEndTimestamp + by).toInt();

    if (newEnd > effectiveEndTimestamp) {
      _visibleEndTimestamp = effectiveStartTimestamp;
      notifyListeners();
      return;
    }

    if (newEnd < _visibleStartTimestamp + leeway) {
      _visibleEndTimestamp = _visibleStartTimestamp + leeway;
      notifyListeners();
      return;
    }

    _visibleEndTimestamp = newEnd;
    notifyListeners();
  }

  void reset() {
    _visibleStartTimestamp = _startTimestamp;
    _visibleEndTimestamp = _endTimestamp;
    notifyListeners();
  }

  void recenter() {
    final center = (_startTimestamp + _endTimestamp) ~/ 2;
    final newRange = _applyTimeScale(center, visibleTimeScale);
    updateVisibleRange(newRange.start, newRange.end);
  }

  void resetZoom() {
    final center = visibleCenterTimestamp;
    final newRange = _applyTimeScale(center, _initialTimeScale);
    updateVisibleRange(newRange.start, newRange.end);
  }
}
