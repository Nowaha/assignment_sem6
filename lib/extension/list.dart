import 'dart:math';

extension ListExtensions<E> on List<E> {
  List<E> takeRange(int start, int end) =>
      getRange(min(start, length), min(end, length)).toList();

  List<E> takePage(int page, int limit) =>
      takeRange(page * limit, (page + 1) * limit);
}
