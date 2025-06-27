import 'package:assignment_sem6/data/dao/memorydao.dart';
import 'package:assignment_sem6/data/dao/postdao.dart';
import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/extension/list.dart';
import 'package:assignment_sem6/mixin/streammixin.dart';
import 'package:assignment_sem6/util/sort.dart';
import 'package:assignment_sem6/util/time.dart';

class MemoryPostDao extends MemoryDao<Post>
    with StreamMixin<Post>
    implements PostDao {
  @override
  Future<void> init() async {
    await insert(
      Post(
        uuid: "4fa88a92-dac7-4cc9-96ee-6d8a698f9743",
        creationTimestamp: Time.nowAsTimestamp(),
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
  Future<List<Post>> get({
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) => safe(() async {
    List<Post> posts = memory.values.toList();
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
    List<Post> posts = memory.values.toList();
    if (posts.isEmpty) return List.empty();

    await _sortPosts(sort, posts);

    return posts.takePage(page, limit);
  });

  @override
  void dispose() => controller.close();
}
