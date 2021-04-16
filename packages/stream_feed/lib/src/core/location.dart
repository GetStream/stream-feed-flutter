/// Location of the cluster
/// the closest to your user it is the less latency they'll have
enum Location {
  /// us East cluster
  usEast,

  /// us West cluster
  euWest,

  /// singapore cluster
  singapore,

  /// tokyo cluster
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
