import 'dart:math';

import 'package:assignment_sem6/data/dao/postdao.dart';
import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/extension/list.dart';
import 'package:assignment_sem6/extension/map.dart';
import 'package:assignment_sem6/mixin/mutexmixin.dart';
import 'package:assignment_sem6/mixin/streammixin.dart';
import 'package:assignment_sem6/util/sort.dart';

class MemoryPostDao extends PostDao with MutexMixin, StreamMixin<Post> {
  final Map<String, Post> _posts = {};

  @override
  Future<void> init() async {
    await insert(
      Post.create(
        creatorUUID: "2ff4e446-504e-4d5d-90e2-ce708f94d20e",
        title: "This is a post!",
      ),
    );
  }

  Future<void> _sortPosts(Sort sort, List<Post> posts) async => posts.sort(
    (a, b) =>
        (sort == Sort.ascending ? 1 : -1) *
        a.creationTimestamp.compareTo(b.creationTimestamp),
  );

  @override
  Future<Iterable<Post>> findAll() => safe(() async => _posts.values);

  @override
  Future<Post?> findByUUID(String uuid) => safe(() async => _posts[uuid]);

  @override
  Future<Map<String, Post>> findByUUIDs(List<String> uuids) =>
      safe(() async => _posts.getAll(uuids));

  @override
  Future<List<Post>> get({
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) => safe(() async {
    List<Post> posts = _posts.values.toList();
    if (posts.isEmpty) return List.empty();

    await _sortPosts(sort, posts);

    return posts.takePage(page, limit);
  });

  @override
  Future<List<Post>> findOfCreator(
    String creatorUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) => safe(() async {
    List<Post> posts = _posts.values.toList();
    if (posts.isEmpty) return List.empty();

    await _sortPosts(sort, posts);

    return posts.takePage(page, limit);
  });

  @override
  Future<void> insert(Post post) => safe(() async {
    if (_posts.containsKey(post.uuid)) {
      throw ArgumentError('A post with the same UUID already exists.');
    }

    _posts[post.uuid] = post;
    controller.add(_posts.values.toList());
  });

  @override
  Future<void> update(Post post) => safe(() async {
    if (!_posts.containsKey(post.uuid)) {
      throw ArgumentError('No post with that UUID exists.');
    }

    _posts[post.uuid] = post;
    controller.add(_posts.values.toList());
  });

  @override
  Future<bool> delete(String uuid) => safe(() async {
    bool success = _posts.remove(uuid) != null;

    if (success) {
      controller.add(_posts.values.toList());
    }

    return success;
  });

  @override
  void dispose() => controller.close();
}
