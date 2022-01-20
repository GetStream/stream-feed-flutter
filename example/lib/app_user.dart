//ignore: public_member_api_docs
class AppUser {
  //ignore: public_member_api_docs
  const AppUser.sahil()
      : id = 'sahil-kumar',
        name = 'Sahil Kumar',
        token =
            '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FoaWwta3VtYXIifQ.QsRdmdDSYV6cOD_Ay9EFgPZmhlgEcGVSB2dOrUTuTI0''';

  //ignore: public_member_api_docs
  const AppUser.sacha()
      : id = 'sacha-arbonel',
        name = 'Sacha Arbonel',
        token =
            '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FjaGEtYXJib25lbCJ9.522mIrFIIKSoDxGEzH1kpFqlEitT1mrWqNGf9VemgHc''';

  //ignore: public_member_api_docs
  const AppUser.nash()
      : id = 'neevash-ramdial',
        name = 'Neevash Ramdial',
        token =
            '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibmVldmFzaC1yYW1kaWFsIn0.RMuwITrfC3PkctN9p90oIcpVQOQRVSHE2emSLD5pbK0'''; //ignore: public_member_api_docs

  //ignore: public_member_api_docs
  const AppUser.reuben()
      : id = 'groovin',
        name = 'Reuben Turner',
        token =
            '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiZ3Jvb3ZpbiJ9.sQQozIjgtxUkgX9QalOM2UYhzQL6UvscsOvrgV1LYsM''';

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
