import 'package:assignment_sem6/data/dao/dao.dart';
import 'package:assignment_sem6/data/entity/entity.dart';
import 'package:assignment_sem6/data/repo/repository.dart';
import 'package:assignment_sem6/data/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

mixin TestWithService<
  E extends Entity,
  D extends Dao<E>,
  R extends Repository<E, D>,
  S extends Service<E, R>
> {
  late final WidgetTester tester;
  late final D dao;
  late final R repo;
  late final S service;

  Future<void> pumpWithService({
    required Widget child,
    List<SingleChildWidget> other = const [],
  }) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [Provider<S>.value(value: service), ...other],
        child: child,
      ),
    );
  }
}
