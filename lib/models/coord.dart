class Coord {
  final double? lon;
  final double? lat;

  const Coord({this.lon, this.lat});

  factory Coord.fromMap(Map<String, dynamic> map) {
    return Coord(
      lon: (map['lon'] as num?)?.toDouble(),
      lat: (map['lat'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'lon': lon,
        'lat': lat,
      };
}
