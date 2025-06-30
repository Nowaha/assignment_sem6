import 'dart:async';

mixin StreamMixin<T> {
  final controller = StreamController<List<T>>.broadcast();

  Stream<List<T>> get stream => controller.stream;

  void notifyListeners(List<T> data) {
    controller.add(data);
  }
}
