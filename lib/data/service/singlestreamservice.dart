import 'package:assignment_sem6/data/dao/singlestreamdao.dart';
import 'package:assignment_sem6/data/entity/entity.dart';
import 'package:assignment_sem6/data/repo/singlestreamrepository.dart';
import 'package:assignment_sem6/data/service/service.dart';

abstract class SingleStreamService<
  E extends Entity,
  R extends SingleStreamRepository<E, SingleStreamDao<E>>
>
    extends Service<E, R> {
  Stream<List<E>> get stream;
  void dispose();
}
