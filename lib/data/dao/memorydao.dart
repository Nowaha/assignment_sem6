import 'package:assignment_sem6/data/dao/dao.dart';
import 'package:assignment_sem6/data/entity/entity.dart';
import 'package:assignment_sem6/extension/map.dart';
import 'package:assignment_sem6/mixin/mutexmixin.dart';
import 'package:flutter/material.dart';

abstract class MemoryDao<E extends Entity> extends Dao<E> with MutexMixin {
  @protected
  final Map<String, E> memory = {};

  @protected
  E? internalFindByUUID(String uuid) => memory[uuid];

  @protected
  Map<String, E> internalGetAll(Iterable<String> uuids) => memory.getAll(uuids);

  @protected
  List<E> internalFindAll() => memory.values.toList();

  @protected
  void internalInsert(E entity) {
    // To mimic unique constraints in a database
    if (internalFindByUUID(entity.uuid) != null) {
      throw ArgumentError("An entity with the same UUID already exists.");
    }

    memory[entity.uuid] = entity;
  }

  @protected
  void internalUpdate(E entity) {
    if (!memory.containsKey(entity.uuid)) {
      throw ArgumentError("No entity with that UUID exists.");
    }
    memory[entity.uuid] = entity;
  }

  @protected
  bool internalDelete(String uuid) => memory.remove(uuid) != null;

  @override
  Future<E?> findByUUID(String uuid) =>
      safe(() async => internalFindByUUID(uuid));

  @override
  Future<Map<String, E>> findByUUIDs(Iterable<String> uuids) =>
      safe(() async => internalGetAll(uuids));

  @override
  Future<List<E>> findAll() => safe(() async => internalFindAll());

  @override
  Future<void> insert(E entity) => safe(() async => internalInsert(entity));

  @override
  Future<void> update(E entity) => safe(() async => internalUpdate(entity));

  @override
  Future<bool> delete(String uuid) => safe(() async => internalDelete(uuid));
}
