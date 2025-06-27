import 'package:assignment_sem6/data/entity/entity.dart';

extension EntityListExtensions<E extends Entity> on Iterable<E> {
  Map<String, E> toUuidMap() => {for (E entity in this) entity.uuid: entity};
}
