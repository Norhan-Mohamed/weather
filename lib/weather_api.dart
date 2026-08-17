import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:weatherapp/config.dart';
import 'package:weatherapp/models/weather_response.dart';

class WeatherException implements Exception {
  final String message;

  const WeatherException(this.message);

  @override
  String toString() => message;
}

class WeatherApi {
  WeatherApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _timeout = Duration(seconds: 15);

  Future<WeatherResponse> fetchByCoordinates({
    double lat = Config.defaultLatitude,
    double lon = Config.defaultLongitude,
  }) {
    return _fetch({
      'lat': '$lat',
      'lon': '$lon',
      'units': 'metric',
      'appid': Config.openWeatherApiKey,
    });
  }

  Future<WeatherResponse> fetchByCity(String city) {
    final trimmed = city.trim();
    if (trimmed.isEmpty) {
      throw const WeatherException('Please enter a city name.');
    }

    return _fetch({
      'q': trimmed,
      'units': 'metric',
      'appid': Config.openWeatherApiKey,
    });
  }

  Future<WeatherResponse> _fetch(Map<String, String> query) async {
    if (Config.openWeatherApiKey.isEmpty) {
      throw const WeatherException(
        'Missing OpenWeatherMap API key in config.dart.',
      );
    }

    final uri = Uri.parse('${Config.openWeatherBaseUrl}/forecast')
        .replace(queryParameters: query);

    try {
      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final decoded = jsonDecode(response.body);
        if (decoded is! Map<String, dynamic>) {
          throw const WeatherException('Unexpected weather data format.');
        }
        return WeatherResponse.fromMap(decoded);
      }

      final body = _tryDecodeError(response.body);
      if (response.statusCode == 404) {
        throw WeatherException(body ?? 'City not found.');
      }
      if (response.statusCode == 401) {
        throw const WeatherException('Invalid API key.');
      }
      throw WeatherException(
        body ?? 'Could not load weather (${response.statusCode}).',
      );
    } on WeatherException {
      rethrow;
    } on SocketException {
      throw const WeatherException(
        'No internet connection. Check your network and try again.',
      );
    } on TimeoutException {
      throw const WeatherException(
        'The request timed out. Please try again.',
      );
    } on http.ClientException {
      throw const WeatherException(
        'No internet connection. Check your network and try again.',
      );
    } on FormatException {
      throw const WeatherException('Could not read weather data.');
    } catch (_) {
      throw const WeatherException(
        'Something went wrong while loading the weather.',
      );
    }
  }

  String? _tryDecodeError(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['message'] != null) {
        return decoded['message'].toString();
      }
    } catch (_) {}
    return null;
  }
}
