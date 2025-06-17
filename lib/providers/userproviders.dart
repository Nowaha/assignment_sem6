import 'package:assignment_sem6/data/dao/impl/memoryuserdao.dart';
import 'package:assignment_sem6/data/dao/userdao.dart';
import 'package:assignment_sem6/data/repo/impl/userrepositoryimpl.dart';
import 'package:assignment_sem6/data/repo/userrepository.dart';
import 'package:assignment_sem6/data/service/impl/userserviceimpl.dart';
import 'package:assignment_sem6/data/service/userservice.dart';
import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:provider/provider.dart';

final userProviders = [
  Provider<UserDao>(create: (_) => MemoryUserDao()..init()),
  ProxyProvider<UserDao, UserRepository>(
    update: (_, dao, __) => UserRepositoryImpl(dao: dao),
  ),
  ProxyProvider<UserRepository, UserService>(
    update: (_, repo, __) => UserServiceImpl(repository: repo),
  ),
  StreamProvider<List<User>>(
    create: (context) => context.read<UserService>().stream,
    initialData: const [],
  ),
];
