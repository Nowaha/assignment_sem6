import 'dart:ui';

import 'package:assignment_sem6/data/entity/entity.dart';
import 'package:assignment_sem6/util/uuid.dart';

class Group extends Entity {
  static final String everyoneUUID = "0000000-0000-0000-0000-000000000000";

  final int creationTimestamp;
  final String name;
  final Color color;
  final List<String> members;

  const Group({
    required super.uuid,
    required this.creationTimestamp,
    required this.name,
    required this.color,
    this.members = const [],
  });

  static Group create({
    required String name,
    required Color color,
    List<String> members = const [],
  }) {
    return Group(
      uuid: UUIDv4.generate(),
      creationTimestamp: DateTime.now().millisecondsSinceEpoch,
      name: name,
      color: color,
      members: members,
    );
  }

  Group copyWith({String? name, Color? color, List<String>? members}) {
    return Group(
      uuid: uuid,
      creationTimestamp: creationTimestamp,
      name: name ?? this.name,
      color: color ?? this.color,
      members: members ?? this.members,
    );
  }
}
