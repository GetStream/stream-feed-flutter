/// Location of the cluster closest to your user.
///
/// The closer the location is to the user, the less latency they'll have.
enum Location {
  /// US East cluster
  usEast,

  /// US West cluster
  euWest,

  /// Singapore cluster
  singapore,

  /// Tokyo cluster
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
