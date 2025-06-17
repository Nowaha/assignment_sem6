import 'package:mutex/mutex.dart';

mixin MutexMixin {
  final Mutex _mutex = Mutex();

  Future<T> safe<T>(Future<T> Function() action) => _mutex.protect(action);
}
