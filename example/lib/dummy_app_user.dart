enum DummyAppUser {
  sahil,
  amit,
  ayush,
}

/// Convenient class Extension on [DummyAppUser] enum
extension DummyAppUserX on DummyAppUser {
  /// Convenient method Extension to generate an [id] from [DummyAppUser] enum
  String get id => {
        DummyAppUser.sahil: 'sahil-kumar',
        DummyAppUser.amit: 'amit-kumar',
        DummyAppUser.ayush: 'ayush-gupta',
      }[this];

  /// Convenient method Extension to generate a [name] from [DummyAppUser] enum
  String get name => {
        DummyAppUser.sahil: 'Sahil Kumar',
        DummyAppUser.amit: 'Amit Kumar',
        DummyAppUser.ayush: 'Ayush P Gupta',
      }[this];

  /// Convenient method Extension to generate [data] from [DummyAppUser] enum
  Map<String, Object> get data => {
        DummyAppUser.sahil: {
          'first_name': 'Sahil',
          'last_name': 'Kumar',
          'full_name': 'Sahil Kumar',
        },
        DummyAppUser.amit: {
          'first_name': 'Amit',
          'last_name': 'Kumar',
          'full_name': 'Amit Kumar',
        },
        DummyAppUser.ayush: {
          'first_name': 'Ayush',
          'last_name': 'Gupta',
          'full_name': 'Ayush P Gupta',
        },
      }[this];
}
