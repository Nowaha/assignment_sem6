import 'package:assignment_sem6/data/entity/impl/resource.dart';
import 'package:assignment_sem6/data/repo/resourcerepository.dart';
import 'package:assignment_sem6/data/service/service.dart';

abstract class ResourceService extends Service<Resource, ResourceRepository> {
  const ResourceService({required super.repository});

  Future<void> addResource(Resource resource);
}
