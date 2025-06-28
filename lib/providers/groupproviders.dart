import 'package:assignment_sem6/data/dao/groupdao.dart';
import 'package:assignment_sem6/data/dao/impl/memorygroupdao.dart';
import 'package:assignment_sem6/data/repo/grouprepository.dart';
import 'package:assignment_sem6/data/repo/impl/grouprepositoryimpl.dart';
import 'package:assignment_sem6/data/repo/userrepository.dart';
import 'package:assignment_sem6/data/service/groupservice.dart';
import 'package:assignment_sem6/data/service/impl/groupserviceimpl.dart';
import 'package:provider/provider.dart';

final groupProviders = [
  Provider<GroupDao>(lazy: false, create: (_) => MemoryGroupDao()..init()),
  ProxyProvider<GroupDao, GroupRepository>(
    update: (_, dao, __) => GroupRepositoryImpl(dao: dao),
  ),
  ProxyProvider2<GroupRepository, UserRepository, GroupService>(
    update:
        (_, groupRepository, userRepository, __) => GroupServiceImpl(
          repository: groupRepository,
          userRepository: userRepository,
        ),
  ),
];
