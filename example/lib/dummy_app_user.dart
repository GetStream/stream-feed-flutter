enum DummyAppUser {
  sahil,
  amit,
  ayush,
}

extension DummyAppUserX on DummyAppUser {
  String get id => {
        DummyAppUser.sahil: 'sahil-kumar',
        DummyAppUser.amit: 'amit-kumar',
        DummyAppUser.ayush: 'ayush-gupta',
      }[this];

  String get name => {
        DummyAppUser.sahil: 'Sahil Kumar',
        DummyAppUser.amit: 'Amit Kumar',
        DummyAppUser.ayush: 'Ayush P Gupta',
      }[this];

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
