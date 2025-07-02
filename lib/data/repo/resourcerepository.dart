import 'package:assignment_sem6/data/dao/resourcedao.dart';
import 'package:assignment_sem6/data/entity/impl/resource.dart';
import 'package:assignment_sem6/data/repo/repository.dart';

abstract class ResourceRepository extends Repository<Resource, ResourceDao> {
  const ResourceRepository({required super.dao});
}
