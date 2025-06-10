import 'package:assignment_sem6/data/dao/dao.dart';
import 'package:assignment_sem6/data/entity/entity.dart';

abstract class SingleStreamDao<E extends Entity> implements Dao<E> {
  Stream<List<E>> get stream;
  void dispose();
}
