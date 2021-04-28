import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:mime/mime.dart';

/// Convenient class Extension on [Map]
extension MapX<K, V> on Map<K, V> {
  /// return a [Map] with no null entries (in their key or values)
  Map<K, V> get nullProtected =>
      Map.from(this)..removeWhere((key, value) => key == null || value == null);
}

/// Useful extension functions for [String]
extension StringX on String {
  /// returns the mime type from the passed file name.
  MediaType? get mimeType {
    if (toLowerCase().endsWith('heic')) {
      return MediaType.parse('image/heic');
    } else {
      final mimeType = lookupMimeType(this);
      if (mimeType == null) return null;
      return MediaType.parse(mimeType);
    }
  }
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
