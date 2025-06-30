import 'package:assignment_sem6/data/dao/memorydao.dart';
import 'package:assignment_sem6/data/dao/postdao.dart';
import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/extension/list.dart';
import 'package:assignment_sem6/mixin/streammixin.dart';
import 'package:assignment_sem6/util/sort.dart';

class MemoryPostDao extends MemoryDao<Post>
    with StreamMixin<Post>
    implements PostDao {
  @override
  Future<void> init() async {}

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
  void internalInsert(Post entity) {
    super.internalInsert(entity);
    notifyListeners(internalFindAll());
  }

  @override
  void internalUpdate(Post entity) {
    super.internalUpdate(entity);
    notifyListeners(internalFindAll());
  }

  @override
  bool internalDelete(String uuid) {
    bool result = super.internalDelete(uuid);
    notifyListeners(internalFindAll());
    return result;
  }

  @override
  void dispose() => controller.close();
}
