import 'package:assignment_sem6/data/dao/memorydao.dart';
import 'package:assignment_sem6/data/dao/resourcedao.dart';
import 'package:assignment_sem6/data/entity/impl/resource.dart';

class MemoryResourceDao extends MemoryDao<Resource> implements ResourceDao {
  @override
  Future<void> init() async {}
}
