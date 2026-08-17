import 'package:weatherapp/models/city.dart';
import 'package:weatherapp/models/forecast_item.dart';

class WeatherResponse {
  final String? cod;
  final int? message;
  final int? cnt;
  final List<ForecastItem> list;
  final City city;

  const WeatherResponse({
    this.cod,
    this.message,
    this.cnt,
    required this.list,
    required this.city,
  });

  factory WeatherResponse.fromMap(Map<String, dynamic> map) {
    final forecasts = (map['list'] as List<dynamic>? ?? [])
        .map((item) => ForecastItem.fromMap(
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();

    return WeatherResponse(
      cod: map['cod']?.toString(),
      message: map['message'] is int
          ? map['message'] as int
          : int.tryParse('${map['message']}'),
      cnt: map['cnt'] as int?,
      list: forecasts,
      city: City.fromMap(Map<String, dynamic>.from(map['city'] as Map)),
    );
  }

  List<ForecastItem> get dailyForecasts {
    final byDay = <String, ForecastItem>{};

    for (final item in list) {
      final key = item.dayKey;
      if (key == null) continue;

      final existing = byDay[key];
      final isNoon = item.dtTxt?.contains('12:00:00') ?? false;
      if (existing == null || isNoon) {
        byDay[key] = item;
      }
    }

    return byDay.values.take(5).toList();
  }

  ({double? min, double? max}) temperatureRangeForDay(String? dayKey) {
    if (dayKey == null) return (min: null, max: null);

    double? minTemp;
    double? maxTemp;

    for (final item in list) {
      if (item.dayKey != dayKey) continue;
      final temp = item.main.temp;
      if (temp == null) continue;
      minTemp = minTemp == null ? temp : (temp < minTemp ? temp : minTemp);
      maxTemp = maxTemp == null ? temp : (temp > maxTemp ? temp : maxTemp);
    }

    return (min: minTemp, max: maxTemp);
  }

  Map<String, dynamic> toMap() => {
        'cod': cod,
        'message': message,
        'cnt': cnt,
        'list': list.map((item) => item.toMap()).toList(),
        'city': city.toMap(),
      };
}
