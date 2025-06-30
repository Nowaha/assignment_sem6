import 'package:assignment_sem6/data/dao/impl/memorypostdao.dart';
import 'package:assignment_sem6/data/dao/postdao.dart';
import 'package:assignment_sem6/data/repo/grouprepository.dart';
import 'package:assignment_sem6/data/repo/impl/postrepositoryimpl.dart';
import 'package:assignment_sem6/data/repo/postrepository.dart';
import 'package:assignment_sem6/data/service/commentservice.dart';
import 'package:assignment_sem6/data/service/impl/postserviceimpl.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/service/userservice.dart';
import 'package:provider/provider.dart';

final postProviders = [
  Provider<PostDao>(lazy: false, create: (_) => MemoryPostDao()..init()),
  ProxyProvider<PostDao, PostRepository>(
    update: (_, dao, __) => PostRepositoryImpl(dao: dao),
  ),
  ProxyProvider4<
    PostRepository,
    UserService,
    CommentService,
    GroupRepository,
    PostService
  >(
    update:
        (_, postRepository, userService, commentService, groupRepository, __) =>
            PostServiceImpl(
              repository: postRepository,
              userService: userService,
              commentService: commentService,
              groupRepository: groupRepository,
            ),
  ),
  StreamProvider<List<Post>>(
    create: (context) => context.read<PostService>().stream,
    initialData: const [],
  ),
];
