///
extension MapX on Map {
  ///
  Map<String, dynamic> get nullProtect {
    return this..removeWhere((key, value) => key == null || value == null);
  }
}

/// Throws an [ArgumentError] if the given [expression] is `false`.
void checkArgument(bool expression, [String message]) {
  if (!(expression ?? false)) {
    throw ArgumentError(message);
  }
}

/// Throws an [ArgumentError] if the given [reference] is `null`. Otherwise,
/// returns the [reference] parameter.
T checkNotNull<T>(T reference, [String message]) {
  if (reference == null) {
    throw ArgumentError(message);
  }
  return reference;
}
