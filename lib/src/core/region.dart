enum Region {
  US_EAST,
  TOKYO,
  DUBLIN,
  SINGAPORE,
  CANADA,
}

extension RegionX on Region {
  String get name => {
        Region.US_EAST: 'us-east-api',
        Region.TOKYO: 'tokyo-api',
        Region.DUBLIN: 'dublin-api',
        Region.SINGAPORE: 'singapore-api',
        Region.CANADA: 'ca-central-1',
      }[this];
}
