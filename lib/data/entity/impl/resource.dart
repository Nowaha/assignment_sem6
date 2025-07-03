import 'dart:typed_data';

import 'package:assignment_sem6/data/entity/entity.dart';
import 'package:assignment_sem6/util/uuid.dart';

class Resource extends Entity {
  final int creationTimestamp;
  final ResourceType type;
  final String name;
  final String originalExtension;
  final Uint8List data;

  Resource({
    required super.uuid,
    required this.creationTimestamp,
    required this.type,
    required this.name,
    required this.originalExtension,
    required this.data,
  });

  static Resource create({
    required ResourceType type,
    required String name,
    required String originalExtension,
    required Uint8List data,
  }) {
    return Resource(
      uuid: UUIDv4.generate(),
      creationTimestamp: DateTime.now().millisecondsSinceEpoch,
      type: type,
      name: name,
      originalExtension: originalExtension,
      data: data,
    );
  }

  @override
  String toString() {
    return "Resource{id: $uuid, creationTimestamp: $creationTimestamp, type: $type, name: $name, originalExtension: $originalExtension, data length: ${data.length}}";
  }
}

enum ResourceType {
  image(["jpg", "jpeg", "png", "gif"]),
  video(["mp4", "avi", "mov"]),
  document(["pdf", "doc", "docx", "ppt", "pptx", "txt"]);

  final List<String> extensions;
  const ResourceType(this.extensions);

  bool isValidExtension(String ext) {
    return extensions.contains(ext.toLowerCase());
  }

  static ResourceType fromExtension(String ext) {
    for (final type in ResourceType.values) {
      if (type.isValidExtension(ext)) {
        return type;
      }
    }
    throw ArgumentError("No valid ResourceType found for extension: $ext");
  }

  static List<String> get allExtensions {
    return ResourceType.values.expand((type) => type.extensions).toList();
  }
}
