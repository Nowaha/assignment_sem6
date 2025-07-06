import 'package:assignment_sem6/state/timelinestate.dart';
import 'package:assignment_sem6/util/uuid.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:assignment_sem6/widgets/view/timeline/timeline.dart';
import 'package:assignment_sem6/widgets/view/timeline/widget/timelineitemwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets("Timeline renders from state", (WidgetTester tester) async {
    // Arrange
    final startTimestamp = 0;
    final endTimestamp = 10000;
    final item = TimelineItem(
      name: "Test Item",
      postUUID: UUIDv4.generate(),
      location: LatLng(1, 2),
      tags: ["test"],
      startTimestamp: startTimestamp,
      endTimestamp: endTimestamp,
      rawLayer: 1,
      layerOffset: 0.0,
    );
    final items = {item.key: item};
    final timelineState = TimelineState(
      items: items,
      startTimestamp: startTimestamp,
      endTimestamp: endTimestamp,
      visibleStartTimestamp: startTimestamp,
      visibleEndTimestamp: endTimestamp,
      initialTimeScale: endTimestamp - startTimestamp,
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<TimelineState>.value(
        value: timelineState,
        child: MaterialApp(home: Scaffold(body: Timeline())),
      ),
    );

    expect(find.byType(TimelineItemWidget), findsOneWidget);
    expect(find.text(item.name), findsOneWidget);
  });
}
