import 'package:assignment_sem6/data/entity/impl/group.dart';
import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/data/service/data/postview.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/util/sort.dart';
import 'package:assignment_sem6/util/validation.dart';

class PostServiceImpl extends PostService {
  PostServiceImpl({
    required super.repository,
    required super.groupRepository,
    required super.userService,
    required super.commentService,
  });

  @override
  Future<PostView?> link(Post? entity) async {
    if (entity == null) return null;

    return PostView(
      post: entity,
      creator: await userService.getByUUID(entity.creatorUUID),
      comments: await commentService.getCommentsOfPostLinked(entity.uuid),
      groups:
          entity.groups.isEmpty
              ? {
                Group.everyoneUUID:
                    (await groupRepository.getByUUID(Group.everyoneUUID))!,
              }
              : await groupRepository.getByUUIDs(entity.groups),
    );
  }

  @override
  Future<Map<String, PostView>> linkAll(Iterable<Post> entities) async {
    Map<String, User> creators = await userService.getByUUIDs(
      entities.map((post) => post.creatorUUID),
    );

    Map<String, PostView> linkedPosts = {};
    for (Post post in entities) {
      linkedPosts[post.uuid] = PostView(
        post: post,
        creator: creators[post.creatorUUID],
        comments: await commentService.getCommentsOfPostLinked(post.uuid),
        groups:
            post.groups.isEmpty
                ? {
                  Group.everyoneUUID:
                      (await groupRepository.getByUUID(Group.everyoneUUID))!,
                }
                : await groupRepository.getByUUIDs(post.groups),
      );
    }
    return linkedPosts;
  }

  @override
  Future<List<Post>> getPosts({
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) => repository.getPosts(sort: sort, limit: limit, page: page);

  @override
  Future<List<Post>> getPostsOfCreator(
    String creatorUUID, {
    Sort sort = Sort.descending,
    int limit = 10,
    int page = 0,
  }) => repository.getPostsOfCreator(
    creatorUUID,
    sort: sort,
    limit: limit,
    page: page,
  );

  @override
  Future<Post> createNewPost(Post post) async {
    if (post.endTimestamp != null && post.endTimestamp! < post.startTimestamp) {
      throw ArgumentError("End timestamp cannot be before start timestamp.");
    }

    if (Validation.isValidPostName(post.title) !=
        PostTitleValidationResult.valid) {
      throw ArgumentError("Post title is invalid.", "post.title");
    }

    if (post.title.isEmpty) {
      throw ArgumentError("Post contents cannot be empty.", "post.contents");
    }

    if (!await userService.existsByUUID(post.creatorUUID)) {
      throw ArgumentError(
        "Creator with UUID ${post.creatorUUID} does not exist.",
        "post.creatorUUID",
      );
    }

    await repository.add(post);
    return post;
  }

  @override
  void dispose() => repository.dispose();

  @override
  Stream<List<Post>> get stream => repository.stream;

  @override
  Future<bool> deletePost(String uuid) => repository.remove(uuid);
}
