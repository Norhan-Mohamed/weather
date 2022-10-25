import 'dart:convert';

import 'package:http/http.dart' as http;

import 'Model/weatherResponse.dart';

class Api {
  Future<WeatherResponse> getData() async {
    final http.Response response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=efd6415be5aba34d7d4852cb8f6ac59d"));
    if (response.statusCode <= 299 && response.statusCode >= 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      WeatherResponse weatherResponse = WeatherResponse.fromMap(body);
      return weatherResponse;
    } else {
      throw ('failed' + response.body);
    }
  }
}
