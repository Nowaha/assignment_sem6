import 'package:assignment_sem6/data/dao/impl/memorypostdao.dart';
import 'package:assignment_sem6/data/dao/postdao.dart';
import 'package:assignment_sem6/data/repo/impl/postrepositoryimpl.dart';
import 'package:assignment_sem6/data/repo/postrepository.dart';
import 'package:assignment_sem6/data/service/impl/postserviceimpl.dart';
import 'package:assignment_sem6/data/service/postservice.dart';
import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:provider/provider.dart';

final postProviders = [
  Provider<PostDao>(create: (_) => MemoryPostDao()..init()),
  ProxyProvider<PostDao, PostRepository>(
    update: (_, dao, __) => PostRepositoryImpl(dao: dao),
  ),
  ProxyProvider<PostRepository, PostService>(
    update: (_, repo, __) => PostServiceImpl(repository: repo),
  ),
  StreamProvider<List<Post>>(
    create: (context) => context.read<PostService>().stream,
    initialData: const [],
  ),
];
