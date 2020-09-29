enum Location {
  us_east,
  eu_west,
  singapore,
  tokyo,
}

extension LocationX on Location {
  String get name => {
        Location.us_east: 'us-east',
        Location.eu_west: 'dublin',
        Location.singapore: 'singapore',
        Location.tokyo: 'tokyo',
      }[this];
}
