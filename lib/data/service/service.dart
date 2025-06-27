import 'package:assignment_sem6/data/dao/dao.dart';
import 'package:assignment_sem6/data/entity/entity.dart';
import 'package:assignment_sem6/data/repo/repository.dart';
import 'package:assignment_sem6/extension/entityiterable.dart';

abstract class Service<E extends Entity, R extends Repository<E, Dao<E>>> {
  final R repository;

  const Service({required this.repository});

  Future<E?> getByUUID(String uuid) => repository.getByUUID(uuid);

  Future<Map<String, E>> getByUUIDs(Iterable<String> uuids) =>
      repository.getByUUIDs(uuids);

  Future<Iterable<E>> getAll() => repository.getAll();

  Future<Map<String, E>> getAllMapped() async => (await getAll()).toUuidMap();
}

abstract class LinkedService<
  E extends Entity,
  V,
  R extends Repository<E, Dao<E>>
>
    extends Service<E, R> {
  const LinkedService({required super.repository});

  Future<V?> link(E? entity);

  Future<Map<String, V>> linkAll(Iterable<E> entities);

  Future<V?> getByUUIDLinked(String uuid) async => link(await getByUUID(uuid));

  Future<Map<String, V>> getByUUIDsLinked(Iterable<String> uuids) async =>
      linkAll((await getByUUIDs(uuids)).values);

  Future<Map<String, V>> getAllLinked() async => linkAll(await getAll());
}
