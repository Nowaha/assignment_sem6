import 'package:assignment_sem6/data/entity/entity.dart';
import 'package:assignment_sem6/util/time.dart';
import 'package:assignment_sem6/util/uuid.dart';

class Comment extends Entity {
  final int creationTimestamp;
  final String postUUID;
  final String creatorUUID;
  final String contents;
  final String? replyToUUID;

  Comment({
    required super.uuid,
    required this.creationTimestamp,
    required this.postUUID,
    required this.creatorUUID,
    required this.contents,
    this.replyToUUID,
  });

  static create({
    required String creatorUUID,
    required String postUUID,
    required String contents,
    String? replyToUUID,
  }) => Comment(
    uuid: UUIDv4.generate(),
    creationTimestamp: Time.nowAsTimestamp(),
    postUUID: postUUID,
    creatorUUID: creatorUUID,
    contents: contents,
    replyToUUID: replyToUUID,
  );
}
