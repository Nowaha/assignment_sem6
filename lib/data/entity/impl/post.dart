import 'package:assignment_sem6/data/entity/entity.dart';
import 'package:assignment_sem6/util/time.dart';
import 'package:assignment_sem6/util/uuid.dart';

class Post extends Entity {
  final int creationTimestamp;
  final String creatorUUID;
  final String title;

  Post({
    required super.uuid,
    required this.creatorUUID,
    required this.creationTimestamp,
    required this.title,
  });

  static create({required String creatorUUID, required String title}) => Post(
    uuid: UUIDv4.generate(),
    creationTimestamp: Time.nowAsTimestamp(),
    creatorUUID: creatorUUID,
    title: title,
  );
}
