/// Used to avoid to serialize properties to json
dynamic readonly(_) => null;

/// Helper class for serialization to and from json
class Serializer {
  /// Used to avoid to serialize properties to json
  static const Function readOnly = readonly;

  /// Takes values in `extra_data` key
  /// and puts them on the root level of the json map
  static Map<String, dynamic>? moveKeysToRoot(
    Map<String, dynamic>? json,
    List<String> topLevelFields,
  ) {
    if (json == null) {
      return json;
    }
    final clone = Map<String, dynamic>.from(json);
    clone['extra_data'] = <String, dynamic>{};

    json.keys.forEach((key) {
      if (!topLevelFields.contains(key)) {
        clone['extra_data'][key] = clone.remove(key);
      }
    });

    return clone;
  }

  /// Takes unknown json keys and puts them in the `extra_data` key
  static Map<String, dynamic> moveKeysToMapInPlace(
    Map<String, dynamic> intermediateMap,
    List<String> topLevelFields,
  ) {
    final clone = Map<String, dynamic>.from(intermediateMap);
    final Map<String, dynamic>? extraData = clone.remove('extra_data');

    extraData?.keys.forEach((key) {
      if (!topLevelFields.contains(key)) {
        clone[key] = extraData[key];
      }
    });

    return clone;
  }
}
