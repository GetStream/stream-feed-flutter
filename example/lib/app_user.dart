//ignore: public_member_api_docs
class AppUser {
  //ignore: public_member_api_docs
  const AppUser.sahil()
      : id = 'sahil-kumar',
        name = 'Sahil Kumar',
        token =
            '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FoaWwta3VtYXIifQ.d6RW5eZedEl949w-IeZ40Ukji3yXfFnMw3baLsow028''';

  //ignore: public_member_api_docs
  const AppUser.sacha()
      : id = 'sacha-arbonel',
        name = 'Sacha Arbonel',
        token =
            '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FjaGEtYXJib25lbCJ9.fzDKEyiQ40J4YYgtZxpeQhn6ajX-GEnKZOOmcb-xa7M''';

  //ignore: public_member_api_docs
  const AppUser.nash()
      : id = 'neevash-ramdial',
        name = 'Neevash Ramdial',
        token =
            '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibmVldmFzaC1yYW1kaWFsIn0.yKqSehu_O5WJGh3-aa5qipnBRs7Qtue-1T9TZhT2ejw'''; //ignore: public_member_api_docs

  const AppUser.reuben()
      : id = 'groovin',
        name = 'Reuben Turner',
        token =
            '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiZ3Jvb3ZpbiJ9.6uMlHDLHpiHubWbcTztZO7NbFFZozuhwgNdrGgObgTE''';

  //ignore: public_member_api_docs
  final String id;

  //ignore: public_member_api_docs
  final String name;

  //ignore: public_member_api_docs
  final String token;

  //ignore: public_member_api_docs
  Map<String, Object> get data {
    final parts = name.split(' ');
    return {
      'first_name': parts[0],
      'last_name': parts[1],
      'full_name': name,
    };
  }
}

//ignore: public_member_api_docs
const appUsers = [
  AppUser.sahil(),
  AppUser.sacha(),
  AppUser.nash(),
  AppUser.reuben(),
];
