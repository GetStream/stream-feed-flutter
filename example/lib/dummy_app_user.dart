enum DummyAppUser {
  sahil,
  sacha,
  nash,
}

/// Convenient class Extension on [DummyAppUser] enum
extension DummyAppUserX on DummyAppUser {
  /// Convenient method Extension to generate an [id] from [DummyAppUser] enum
  String? get id => {
        DummyAppUser.sahil: 'sahil-kumar',
        DummyAppUser.sacha: 'sacha-arbonel',
        DummyAppUser.nash: 'neevash-ramdial',
      }[this];

  /// Convenient method Extension to generate a [name] from [DummyAppUser] enum
  String? get name => {
        DummyAppUser.sahil: 'Sahil Kumar',
        DummyAppUser.sacha: 'Sacha Arbonel',
        DummyAppUser.nash: 'Neevash Ramdial',
      }[this];

  /// Convenient method Extension to generate [data] from [DummyAppUser] enum
  Map<String, Object>? get data => {
        DummyAppUser.sahil: {
          'first_name': 'Sahil',
          'last_name': 'Kumar',
          'full_name': 'Sahil Kumar',
        },
        DummyAppUser.sacha: {
          'first_name': 'Sacha',
          'last_name': 'Arbonel',
          'full_name': 'Sacha Arbonel',
        },
        DummyAppUser.nash: {
          'first_name': 'Neevash',
          'last_name': 'Ramdial',
          'full_name': 'Neevash Ramdial',
        },
      }[this];
}
