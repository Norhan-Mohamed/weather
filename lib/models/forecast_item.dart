import 'package:weatherapp/models/clouds.dart';
import 'package:weatherapp/models/main_details.dart';
import 'package:weatherapp/models/system.dart';
import 'package:weatherapp/models/weather_description.dart';
import 'package:weatherapp/models/wind.dart';

class ForecastItem {
  final int? dt;
  final MainDetails main;
  final List<WeatherDescription> weather;
  final Clouds clouds;
  final Wind wind;
  final int? visibility;
  final double? pop;
  final System sys;
  final String? dtTxt;

  const ForecastItem({
    this.dt,
    required this.main,
    required this.weather,
    required this.clouds,
    required this.wind,
    this.visibility,
    this.pop,
    required this.sys,
    this.dtTxt,
  });

  factory ForecastItem.fromMap(Map<String, dynamic> map) {
    final weatherList = (map['weather'] as List<dynamic>? ?? [])
        .map((item) => WeatherDescription.fromMap(
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();

    return ForecastItem(
      dt: map['dt'] as int?,
      main: MainDetails.fromMap(Map<String, dynamic>.from(map['main'] as Map)),
      weather: weatherList,
      clouds: Clouds.fromMap(Map<String, dynamic>.from(map['clouds'] as Map)),
      wind: Wind.fromMap(Map<String, dynamic>.from(map['wind'] as Map)),
      visibility: map['visibility'] as int?,
      pop: (map['pop'] as num?)?.toDouble(),
      sys: System.fromMap(Map<String, dynamic>.from(map['sys'] as Map)),
      dtTxt: map['dt_txt'] as String?,
    );
  }

  WeatherDescription? get primaryWeather =>
      weather.isEmpty ? null : weather.first;

  DateTime? get dateTime {
    if (dt == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(dt! * 1000, isUtc: true)
        .toLocal();
  }

  String? get dayKey {
    if (dtTxt != null && dtTxt!.contains(' ')) {
      return dtTxt!.split(' ').first;
    }
    final local = dateTime;
    if (local == null) return null;
    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toMap() => {
        'dt': dt,
        'main': main.toMap(),
        'weather': weather.map((item) => item.toMap()).toList(),
        'clouds': clouds.toMap(),
        'wind': wind.toMap(),
        'visibility': visibility,
        'pop': pop,
        'sys': sys.toMap(),
        'dt_txt': dtTxt,
      };
}
