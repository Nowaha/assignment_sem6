import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/widgets/view/filter/locationrect.dart';

class Filters {
  final String searchQuery;
  final DateTime startDate;
  final DateTime endDate;
  late final List<String> searchQuerySplit;
  final LocationRect? locationRect;
  final Map<String, String> groups;

  Filters({
    required this.searchQuery,
    required this.startDate,
    required this.endDate,
    this.groups = const {},
    this.locationRect,
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
    Map<String, String>? groups,
  }) {
    return Filters(
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      groups: groups ?? this.groups,
      locationRect: locationRect,
    );
  }

  Filters copyWithLocation(LocationRect? newLocationRect) {
    return Filters(
      searchQuery: searchQuery,
      startDate: startDate,
      endDate: endDate,
      groups: groups,
      locationRect: newLocationRect,
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
    if (post.startTimestamp > endDate.millisecondsSinceEpoch ||
        (post.endTimestamp != null &&
            post.endTimestamp! < startDate.millisecondsSinceEpoch)) {
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

    if (locationRect != null) {
      if (!locationRect!.contains(post.lat, post.lng)) {
        return false;
      }
    }

    if (groups.isNotEmpty) {
      if (!groups.values.any((groupUuid) => post.groups.contains(groupUuid))) {
        return false;
      }
    }

    return true;
  }
}
