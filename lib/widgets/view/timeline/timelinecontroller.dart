import 'package:assignment_sem6/widgets/view/timeline/timeline.dart';
import 'package:flutter/material.dart';

typedef Range = ({int start, int end});

class TimelineController extends ChangeNotifier {
  List<TimelineItem> _items;
  int _startTimestamp;
  int _endTimestamp;

  int _visibleStartTimestamp;
  int _visibleEndTimestamp;

  TimelineController({
    required List<TimelineItem> items,
    required int startTimestamp,
    required int endTimestamp,
    required int visibleStartTimestamp,
    required int visibleEndTimestamp,
    int centerOffset = 0,
    double zoom = 1.0,
  }) : _items = items,
       _startTimestamp = startTimestamp,
       _endTimestamp = endTimestamp,
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

  int get visibleStartTimestamp => _visibleStartTimestamp;
  int get visibleEndTimestamp => _visibleEndTimestamp;
  int get visibleCenterTimestamp =>
      (_visibleStartTimestamp + _visibleEndTimestamp) ~/ 2;
  Range get visibleRange => (
    start: _visibleStartTimestamp,
    end: _visibleEndTimestamp,
  );

  int get visibleTimeScale => _visibleEndTimestamp - _visibleStartTimestamp;

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
    notifyListeners();
  }

  void updateTimestamps(int newStart, int newEnd) {
    startTimestamp = newStart;
    endTimestamp = newEnd;
    notifyListeners();
  }

  void updateVisibleRange(int newVisibleStart, int newVisibleEnd) {
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
    _visibleStartTimestamp = newRange.start;
    _visibleEndTimestamp = newRange.end;
    notifyListeners();
  }

  static Range _zoom(int center, Range old, double factor) {
    final difference = (old.end - old.start) ~/ 2;
    final newDifference = (difference / factor).toInt();
    final newStart = center - newDifference;
    final newEnd = center + newDifference;
    return (start: newStart, end: newEnd);
  }

  void zoom(double factor) {
    final newValues = _zoom(visibleCenterTimestamp, visibleRange, factor);
    _visibleStartTimestamp = newValues.start;
    _visibleEndTimestamp = newValues.end;
    notifyListeners();
  }

  static Range _applyTimeScale(int center, int timeScale) {
    final newStart = center - timeScale ~/ 2;
    final newEnd = center + timeScale ~/ 2;
    return (start: newStart, end: newEnd);
  }

  void applyTimeScale(int timeScale) {
    final newRange = _applyTimeScale(centerTimestamp, timeScale);
    _visibleStartTimestamp = newRange.start;
    _visibleEndTimestamp = newRange.end;
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
    _visibleStartTimestamp = newRange.start;
    _visibleEndTimestamp = newRange.end;
    notifyListeners();
  }

  void resetZoom() {
    final center = visibleCenterTimestamp;
    final newRange = _applyTimeScale(center, endTimestamp - startTimestamp);
    _visibleStartTimestamp = newRange.start;
    _visibleEndTimestamp = newRange.end;
    notifyListeners();
  }
}
