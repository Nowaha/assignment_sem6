import 'package:assignment_sem6/data/entity/impl/resource.dart';
import 'package:assignment_sem6/data/service/resourceservice.dart';

class ResourceServiceImpl extends ResourceService {
  const ResourceServiceImpl({required super.repository});

  @override
  Future<void> addResource(Resource resource) async {
    if (await existsByUUID(resource.uuid)) {
      throw Exception("Resource with UUID ${resource.uuid} already exists");
    }
    return repository.add(resource);
  }
}
