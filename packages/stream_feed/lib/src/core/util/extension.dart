/// Convenient class Extension on [Map]
extension MapX<K, V> on Map<K, V> {
  /// return a [Map] with no null entries (in their key or values)
  Map<K, V> get nullProtected =>
      this..removeWhere((key, value) => key == null || value == null);
}

/// Throws an [ArgumentError] if the given [expression] is `false`.
void checkArgument(bool expression, [String? message]) {
  if (!expression) {
    throw ArgumentError(message);
  }
}

/// Throws an [ArgumentError] if the given [reference] is `null`. Otherwise,
/// returns the [reference] parameter.
T checkNotNull<T>(T reference, [String? message]) {
  if (reference == null) {
    throw ArgumentError(message);
  }
  return reference;
}
