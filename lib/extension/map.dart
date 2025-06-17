extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> getAll(List<K> keys) {
    final Map<K, V> result = {};
    for (final key in keys) {
      final value = this[key];
      if (value != null) {
        result[key] = value;
      }
    }
    return result;
  }
}
