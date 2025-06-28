import 'package:assignment_sem6/data/dao/commentdao.dart';
import 'package:assignment_sem6/data/dao/impl/memorycommentdao.dart';
import 'package:assignment_sem6/data/repo/commentrepository.dart';
import 'package:assignment_sem6/data/repo/impl/commentrepositoryimpl.dart';
import 'package:assignment_sem6/data/service/commentservice.dart';
import 'package:assignment_sem6/data/service/impl/commentserviceimpl.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/data/service/userservice.dart';
import 'package:provider/provider.dart';

final commentProviders = [
  Provider<CommentDao>(lazy: false, create: (_) => MemoryCommentDao()..init()),
  ProxyProvider<CommentDao, CommentRepository>(
    update: (_, dao, __) => CommentRepositoryImpl(dao: dao),
  ),
  ProxyProvider2<CommentRepository, UserService, CommentService>(
    update:
        (_, commentRepository, userService, __) => CommentServiceImpl(
          repository: commentRepository,
          userService: userService,
        ),
  ),
  StreamProvider<List<Post>>(
    create: (context) => context.read<PostService>().stream,
    initialData: const [],
  ),
];
