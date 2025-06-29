import 'package:assignment_sem6/data/entity/impl/post.dart';

class Filters {
  final String searchQuery;
  final DateTime startDate;
  final DateTime endDate;
  late final List<String> searchQuerySplit;

  Filters({
    required this.searchQuery,
    required this.startDate,
    required this.endDate,
  }) {
    searchQuerySplit =
        searchQuery
            .trim()
            .split(" ")
            .map((item) => item.trim().toLowerCase())
            .toList();
  }

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

  bool tagMatches(Post post) {
    for (final word in searchQuerySplit) {
      if (word.isEmpty) continue;

      if (post.tags.any((tag) => tag.toLowerCase().contains(word))) {
        continue;
      } else {
        return false;
      }
    }

    return true;
  }

  bool matches(Post post) {
    if (post.startTimestamp < startDate.millisecondsSinceEpoch) {
      return false;
    }
    if (post.endTimestamp != null &&
        post.endTimestamp! > endDate.millisecondsSinceEpoch) {
      return false;
    }

    if (searchQuery.isNotEmpty) {
      final lowerSearchQuery = searchQuery.toLowerCase();

      if (!post.title.toLowerCase().contains(lowerSearchQuery) &&
          !post.postContents.toLowerCase().contains(lowerSearchQuery) &&
          !tagMatches(post)) {
        return false;
      }
    }

    return true;
  }
}
