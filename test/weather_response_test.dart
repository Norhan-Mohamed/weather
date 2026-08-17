import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapp/models/weather_response.dart';

void main() {
  test('parses forecast response and builds daily forecasts', () {
    final response = WeatherResponse.fromMap({
      'cod': '200',
      'message': 0,
      'cnt': 3,
      'list': [
        {
          'dt': 1700000000,
          'main': {
            'temp': 20.4,
            'feels_like': 19.0,
            'temp_min': 18.0,
            'temp_max': 22.0,
            'pressure': 1012,
            'sea_level': 1012,
            'grnd_level': 980,
            'humidity': 60,
            'temp_kf': 0.0,
          },
          'weather': [
            {
              'id': 800,
              'main': 'Clear',
              'description': 'clear sky',
              'icon': '01d',
            }
          ],
          'clouds': {'all': 0},
          'wind': {'speed': 3.2, 'deg': 180},
          'visibility': 10000,
          'pop': 0,
          'sys': {'pod': 'd'},
          'dt_txt': '2023-11-14 09:00:00',
        },
        {
          'dt': 1700010800,
          'main': {
            'temp': 23.1,
            'feels_like': 22.0,
            'temp_min': 20.0,
            'temp_max': 24.0,
            'pressure': 1011,
            'humidity': 55,
            'temp_kf': 0.0,
          },
          'weather': [
            {
              'id': 801,
              'main': 'Clouds',
              'description': 'few clouds',
              'icon': '02d',
            }
          ],
          'clouds': {'all': 20},
          'wind': {'speed': 4.1, 'deg': 190, 'gust': 6.0},
          'visibility': 10000,
          'pop': 0.1,
          'sys': {'pod': 'd'},
          'dt_txt': '2023-11-14 12:00:00',
        },
        {
          'dt': 1700097200,
          'main': {
            'temp': 18.0,
            'feels_like': 17.0,
            'temp_min': 16.0,
            'temp_max': 19.0,
            'pressure': 1010,
            'humidity': 70,
            'temp_kf': 0.0,
          },
          'weather': [
            {
              'id': 500,
              'main': 'Rain',
              'description': 'light rain',
              'icon': '10d',
            }
          ],
          'clouds': {'all': 80},
          'wind': {'speed': 5.0, 'deg': 200},
          'visibility': 8000,
          'pop': 0.4,
          'sys': {'pod': 'd'},
          'dt_txt': '2023-11-15 12:00:00',
        },
      ],
      'city': {
        'id': 1,
        'name': 'Modena',
        'coord': {'lat': 44.34, 'lon': 10.99},
        'country': 'IT',
        'population': 100000,
        'timezone': 7200,
        'sunrise': 1700000000,
        'sunset': 1700040000,
      },
    });

    expect(response.city.displayName, 'Modena, IT');
    expect(response.list.length, 3);
    expect(response.list.first.wind.gust, isNull);
    expect(response.list[1].wind.gust, 6.0);
    expect(response.dailyForecasts.length, 2);
    expect(response.dailyForecasts.first.main.temp, 23.1);
    expect(response.temperatureRangeForDay('2023-11-14').min, 20.4);
    expect(response.temperatureRangeForDay('2023-11-14').max, 23.1);
  });
}
