import 'package:assignment_sem6/data/dao/dao.dart';
import 'package:assignment_sem6/data/entity/entity.dart';

abstract class Repository<E extends Entity, D extends Dao<E>> {
  D get dao;

  Future<E?> getByUUID(String uuid) => dao.findByUUID(uuid);
  Future<Iterable<E>> getAll() => dao.findAll();
  Future<void> add(E entity) => dao.insert(entity);
  Future<void> update(E entity) => dao.update(entity);
  Future<bool> remove(String uuid) => dao.delete(uuid);
}