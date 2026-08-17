import 'package:weatherapp/models/coord.dart';

class City {
  final int? id;
  final String? name;
  final Coord coord;
  final String? country;
  final int? population;
  final int? timezone;
  final int? sunrise;
  final int? sunset;

  const City({
    this.id,
    this.name,
    required this.coord,
    this.country,
    this.population,
    this.timezone,
    this.sunrise,
    this.sunset,
  });

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'] as int?,
      name: map['name'] as String?,
      coord: Coord.fromMap(Map<String, dynamic>.from(map['coord'] as Map)),
      country: map['country'] as String?,
      population: map['population'] as int?,
      timezone: map['timezone'] as int?,
      sunrise: map['sunrise'] as int?,
      sunset: map['sunset'] as int?,
    );
  }

  String get displayName {
    final cityName = name ?? 'Unknown';
    if (country == null || country!.isEmpty) return cityName;
    return '$cityName, $country';
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'coord': coord.toMap(),
        'country': country,
        'population': population,
        'timezone': timezone,
        'sunrise': sunrise,
        'sunset': sunset,
      };
}
