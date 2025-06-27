import 'package:assignment_sem6/data/dao/singlestreamdao.dart';
import 'package:assignment_sem6/data/entity/entity.dart';
import 'package:assignment_sem6/data/repo/repository.dart';

abstract class SingleStreamRepository<
  E extends Entity,
  D extends SingleStreamDao<E>
>
    extends Repository<E, D> {
  SingleStreamRepository({required super.dao});

  Stream<List<E>> get stream => dao.stream;
  void dispose() => dao.dispose();
}
