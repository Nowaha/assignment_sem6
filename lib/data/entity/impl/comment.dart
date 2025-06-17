import 'package:assignment_sem6/data/entity/entity.dart';
import 'package:assignment_sem6/util/time.dart';
import 'package:assignment_sem6/util/uuid.dart';

class Comment implements Entity {
  final String uuid; // Unique
  final int creationTimestamp;
  final String postUUID;
  final String creatorUUID;
  final String contents;

  Comment({
    required this.uuid,
    required this.creationTimestamp,
    required this.postUUID,
    required this.creatorUUID,
    required this.contents,
  });

  static create({
    required String creatorUUID,
    required String postUUID,
    required String contents,
  }) => Comment(
    uuid: UUIDv4.generate(),
    creationTimestamp: Time.nowAsTimestamp(),
    postUUID: postUUID,
    creatorUUID: creatorUUID,
    contents: contents,
  );
}
