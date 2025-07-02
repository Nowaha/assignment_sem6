import 'dart:typed_data';

import 'package:assignment_sem6/data/entity/entity.dart';
import 'package:assignment_sem6/util/uuid.dart';

class Resource extends Entity {
  final int creationTimestamp;
  final ResourceType type;
  final Uint8List data;

  Resource({
    required super.uuid,
    required this.creationTimestamp,
    required this.type,
    required this.data,
  });

  static Resource create({
    required ResourceType type,
    required Uint8List data,
  }) {
    return Resource(
      uuid: UUIDv4.generate(),
      creationTimestamp: DateTime.now().millisecondsSinceEpoch,
      type: type,
      data: data,
    );
  }

  @override
  String toString() {
    return 'Resource{id: $uuid, creationTimestamp: $creationTimestamp, type: $type, data length: ${data.length}}';
  }
}

enum ResourceType { image, video, document }
