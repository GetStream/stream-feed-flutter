enum Location {
  usEast,
  euWest,
  singapore,
  tokyo,
}

extension LocationX on Location {
  String get name => {
        Location.usEast: 'us-east',
        Location.euWest: 'dublin',
        Location.singapore: 'singapore',
        Location.tokyo: 'tokyo',
      }[this];
}
