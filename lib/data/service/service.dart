import 'package:assignment_sem6/data/dao/dao.dart';
import 'package:assignment_sem6/data/entity/entity.dart';
import 'package:assignment_sem6/data/repo/repository.dart';

abstract class Service<E extends Entity, R extends Repository<E, Dao<E>>> {
  R get repository;

  Future<E?> getByUUID(String uuid) => repository.getByUUID(uuid);
  
  Future<Iterable<E>> getAll() => repository.getAll();

  Future<void> add(E entity) => repository.add(entity);

  Future<void> update(E entity) => repository.update(entity);

  Future<void> delete(String uuid) => repository.remove(uuid);
}