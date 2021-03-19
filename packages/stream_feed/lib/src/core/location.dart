enum Location {
  usEast,
  euWest,
  singapore,
  tokyo,
}

/// Convenient class Extension to on [Location] enum
extension LocationX on Location {
  /// Convenient method Extension to generate [name] from [DummyAppUser] enum
  String? get name => {
        Location.usEast: 'us-east',
        Location.euWest: 'dublin',
        Location.singapore: 'singapore',
        Location.tokyo: 'tokyo',
      }[this];
}
