import 'package:weatherapp/Model/Coord.dart';

class City {
  late int id;
  late String name;
  late Coord coord;
  late String country;
  late int population;
  late int timezone;
  late int sunrise;
  late int sunset;

  City({
    required this.id,
    required this.name,
    required this.coord,
    required this.country,
    required this.population,
    required this.sunrise,
    required this.sunset,
    required this.timezone,
  });
  City.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    coord = Coord.fromMap(map['coord']);
    country = map['country'];
    population = map['populatio'];
    timezone = map['timezone'];
    sunrise = map['sunrize'];
    sunset = map['sunset'];
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': this.id,
      'name': this.name,
      'coord': this.coord.toMap(),
      'counrty': this.country,
      'population': this.population,
      'sunrise': this.sunrise,
      'timezone': this.timezone,
      'sunset': this.sunset,
    };
    return map;
  }
}
