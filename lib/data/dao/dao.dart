import 'package:assignment_sem6/data/entity/entity.dart';

abstract class Dao<E extends Entity> {
  Future<void> init();
  Future<E?> findByUUID(String uuid);
  Future<Map<String, E>> findByUUIDs(Iterable<String> uuids);
  Future<Iterable<E>> findAll();
  Future<void> insert(E entity);
  Future<void> update(E entity);
  Future<bool> delete(String uuid);
}
