import 'package:weatherapp/Model/Clouds.dart';
import 'package:weatherapp/Model/Wind.dart';
import 'package:weatherapp/Model/description.dart';
import 'package:weatherapp/Model/mainDetails.dart';
import 'package:weatherapp/Model/system.dart';

class SingleForecastRead {
  late int? dt;
  late MainDetails main;
  late List<WeatherDescription> weather;
  late Clouds clouds;
  late Wind wind;
  late int? visibility;
  late double pop;
  late System sys;
  late String dt_txt;

  SingleForecastRead({
    required this.dt,
    required this.main,
    required this.weather,
    required this.clouds,
    required this.wind,
    required this.visibility,
    required this.pop,
    required this.sys,
    required this.dt_txt,
  });

  SingleForecastRead.fromMap(Map<String, dynamic> map) {
    this.dt = map['dt'];
    print('---1');
    this.main = MainDetails.fromMap(map['main']);
    print("----2");
    this.weather = [];
    (map['weather'] as List).forEach((element) {
      this.weather.add(WeatherDescription.fromMap(element));
    });
    print("-----3");
    this.clouds = Clouds.fromMap(map['clouds']);
    print('-------4');
    this.wind = Wind.fromMap(map['wind']);
    print('-------5');
    this.visibility = map['visibility'];
    print('-------6');
    this.pop = double.parse(map['pop'].toString());
    print('-------7');
    this.sys = System.fromMap(map['sys']);
    print('-------8');
    this.dt_txt = map['dt_txt'];
    print('-------9');
  }
  Map<String, dynamic> toMap() {
    List<Map> tmpList = [];
    this.weather.forEach((element) {
      tmpList.add(element.toMap());
    });

    Map<String, dynamic> map = {
      "dt": this.dt,
      "main": this.main.toMap(),
      "weather": tmpList,
      "clouds": this.clouds.toMap(),
      "wind": this.wind.toMap(),
      "visibility": this.visibility,
      "pop": this.pop,
      "sys": this.sys.toMap(),
      "dt_txt": this.dt_txt,
    };
    return map;
  }
}
