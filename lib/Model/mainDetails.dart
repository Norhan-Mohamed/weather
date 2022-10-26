class MainDetails {
  late double? temp;
  late double? feels_like;
  late double? temp_min;
  late double? temp_max;
  late int? pressure;
  //late int see_level;
  late int? grnd_level;
  late int? humidity;
  late double? temp_kf;

  MainDetails({
    required this.temp,
    required this.feels_like,
    required this.temp_min,
    required this.temp_max,
    required this.pressure,
    //required this.see_level,
    required this.grnd_level,
    required this.humidity,
    required this.temp_kf,
  });
  MainDetails.fromMap(Map<String, dynamic> map) {
    this.temp = double.parse(map['temp'].toString());
    this.feels_like = double.parse(map['feels_like'].toString());
    this.temp_min = double.parse(map['temp_min'].toString());
    this.temp_max = double.parse(map['temp_max'].toString());
    this.pressure = int.parse(map['pressure'].toString());
    //this.see_level = int.parse(map['see_level'].toString());
    print("----1--");
    this.grnd_level = int.parse(map['grnd_level'].toString());
    this.humidity = int.parse(map['humidity'].toString());
    print('"---2---');
    this.temp_kf = double.parse(map['temp_kf'].toString());
  }

  Map<String, dynamic> toMap() {
    return {
      "temp": this.temp,
      "feels_like": this.feels_like,
      "temo_min": this.temp_min,
      "temp_max": this.temp_max,
      "pressure": this.pressure,
      // "see_level": this.see_level,
      "grnd_level": this.grnd_level,
      "humidity": this.humidity,
      "temp_kf": this.temp_kf,
    };
  }
}
