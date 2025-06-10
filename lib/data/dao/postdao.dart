import 'package:assignment_sem6/data/dao/singlestreamdao.dart';
import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/util/sort.dart';

abstract class PostDao extends SingleStreamDao<Post> {
  Future<List<Post>> get({Sort sort, int limit, int page});
  Future<List<Post>> findOfCreator(
    String creatorUUID, {
    Sort sort,
    int limit,
    int page,
  });
}
