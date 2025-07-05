import 'package:assignment_sem6/state/timelinestate.dart';
import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:provider/provider.dart';

final _startTimestamp = DateTime.now().subtract(const Duration(days: 1));
final _endTimestamp = DateTime.now();
final timelineProviders = [
  ChangeNotifierProvider(
    create:
        (_) => TimelineState.withTimeScale(
          items: {},
          startTimestamp: _startTimestamp.millisecondsSinceEpoch,
          endTimestamp: _endTimestamp.millisecondsSinceEpoch,
          timeScale: TimelineUtil.calculateInitialTimeScale(
            _startTimestamp.millisecondsSinceEpoch,
            _endTimestamp.millisecondsSinceEpoch,
          ),
        ),
  ),
];
