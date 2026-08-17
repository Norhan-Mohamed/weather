class MainDetails {
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? seaLevel;
  final int? grndLevel;
  final int? humidity;
  final double? tempKf;

  const MainDetails({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.seaLevel,
    this.grndLevel,
    this.humidity,
    this.tempKf,
  });

  factory MainDetails.fromMap(Map<String, dynamic> map) {
    return MainDetails(
      temp: (map['temp'] as num?)?.toDouble(),
      feelsLike: (map['feels_like'] as num?)?.toDouble(),
      tempMin: (map['temp_min'] as num?)?.toDouble(),
      tempMax: (map['temp_max'] as num?)?.toDouble(),
      pressure: (map['pressure'] as num?)?.toInt(),
      seaLevel: (map['sea_level'] as num?)?.toInt(),
      grndLevel: (map['grnd_level'] as num?)?.toInt(),
      humidity: (map['humidity'] as num?)?.toInt(),
      tempKf: (map['temp_kf'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'temp': temp,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'pressure': pressure,
        'sea_level': seaLevel,
        'grnd_level': grndLevel,
        'humidity': humidity,
        'temp_kf': tempKf,
      };
}
