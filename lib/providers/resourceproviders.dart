import 'package:assignment_sem6/data/dao/impl/memoryresourcedao.dart';
import 'package:assignment_sem6/data/dao/resourcedao.dart';
import 'package:assignment_sem6/data/repo/impl/resourcerepositoryimpl.dart';
import 'package:assignment_sem6/data/repo/resourcerepository.dart';
import 'package:assignment_sem6/data/service/impl/resourceserviceimpl.dart';
import 'package:assignment_sem6/data/service/resourceservice.dart';
import 'package:provider/provider.dart';

final resourceProviders = [
  Provider<ResourceDao>(
    lazy: false,
    create: (_) => MemoryResourceDao()..init(),
  ),
  ProxyProvider<ResourceDao, ResourceRepository>(
    update: (_, dao, __) => ResourceRepositoryImpl(dao: dao),
  ),
  ProxyProvider<ResourceRepository, ResourceService>(
    update: (_, repo, __) => ResourceServiceImpl(repository: repo),
  ),
];
