import 'package:assignment_sem6/data/entity/impl/post.dart';

class Filters {
  final String searchQuery;
  final DateTime startDate;
  final DateTime endDate;

  const Filters({
    required this.searchQuery,
    required this.startDate,
    required this.endDate,
  });

  Filters copyWith({
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Filters(
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  bool matches(Post post) {
    if (post.startTimestamp < startDate.millisecondsSinceEpoch) {
      return false;
    }
    if (post.endTimestamp != null &&
        post.endTimestamp! > endDate.millisecondsSinceEpoch) {
      return false;
    }
    return true;
  }
}
