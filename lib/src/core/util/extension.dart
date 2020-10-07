extension MapX on Map {
  Map<String, dynamic> get nullProtect =>
      this..removeWhere((key, value) => key == null || value == null);
}
