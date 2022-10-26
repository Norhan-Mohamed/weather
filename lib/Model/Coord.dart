class Coord {
  late double? lon;
  late double? lat;

  Coord({required this.lon, required this.lat});

  Coord.fromMap(Map<String, dynamic> map) {
    this.lon = map['lon'];
    this.lat = map['lat'];
  }

  Map<String, dynamic> toMap() {
    return {
      'lon': this.lon,
      'lat': this.lat,
    };
  }
}
