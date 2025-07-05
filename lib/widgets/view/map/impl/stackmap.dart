import 'package:assignment_sem6/widgets/view/map/basemap.dart';
import 'package:flutter/material.dart';

abstract class StackMap extends BaseMapWidget {
  const StackMap({super.key, super.initialCenter, super.initialZoom});

  @override
  StackMapState createState();
}

abstract class StackMapState<T extends StackMap> extends BaseMapState<T> {
  List<Widget> getStackItems(BuildContext context);

  @override
  Widget buildWidget(BuildContext context) =>
      Stack(children: [...getStackItems(context)]);
}
