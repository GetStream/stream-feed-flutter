class AppUser {
  final String id;
  final String name;
  final String token;

  const AppUser.sahil()
      : id = 'sahil-kumar',
        name = 'Sahil Kumar',
        token =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FoaWwta3VtYXIifQ.d6RW5eZedEl949w-IeZ40Ukji3yXfFnMw3baLsow028';

  const AppUser.sacha()
      : id = 'sacha-arbonel',
        name = 'Sacha Arbonel',
        token =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FjaGEtYXJib25lbCJ9.fzDKEyiQ40J4YYgtZxpeQhn6ajX-GEnKZOOmcb-xa7M';

  const AppUser.nash()
      : id = 'neevash-ramdial',
        name = 'Neevash Ramdial',
        token =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibmVldmFzaC1yYW1kaWFsIn0.yKqSehu_O5WJGh3-aa5qipnBRs7Qtue-1T9TZhT2ejw';

  Map<String, Object> get data {
    final parts = name.split(' ');
    return {
      'first_name': parts[0],
      'last_name': parts[1],
      'full_name': name,
    };
  }
}

const appUsers = [
  AppUser.sahil(),
  AppUser.sacha(),
  AppUser.nash(),
];
