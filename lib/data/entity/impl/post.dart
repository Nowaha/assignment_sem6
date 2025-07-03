import 'package:assignment_sem6/data/entity/entity.dart';
import 'package:assignment_sem6/util/time.dart';
import 'package:assignment_sem6/util/uuid.dart';
import 'package:latlong2/latlong.dart';

class Post extends Entity {
  final int creationTimestamp;
  final String creatorUUID;
  final int startTimestamp;
  final int? endTimestamp;
  final String title;
  final String postContents;
  final double lat;
  final double lng;
  final List<String> tags;
  final List<String> groups;
  final List<String> attachments;

  get isSinglePoint => endTimestamp == startTimestamp;
  get isEndless => endTimestamp == null;

  const Post({
    required super.uuid,
    required this.creatorUUID,
    required this.creationTimestamp,
    required this.startTimestamp,
    this.endTimestamp,
    required this.title,
    required this.postContents,
    required this.lat,
    required this.lng,
    this.tags = const [],
    this.groups = const [],
    this.attachments = const [],
  });

  static create({
    required String creatorUUID,
    required String title,
    required String postContents,
    required int startTimestamp,
    int? endTimestamp,
    required LatLng latLng,
    List<String> tags = const [],
    List<String> groups = const [],
    List<String> attachments = const [],
  }) => Post(
    uuid: UUIDv4.generate(),
    creationTimestamp: Time.nowAsTimestamp(),
    creatorUUID: creatorUUID,
    startTimestamp: startTimestamp,
    endTimestamp: endTimestamp,
    title: title,
    postContents: postContents,
    lat: latLng.latitude,
    lng: latLng.longitude,
    tags: tags,
    groups: groups,
    attachments: attachments,
  );
}
