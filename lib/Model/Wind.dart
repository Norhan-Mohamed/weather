class Wind {
  late double? speed;
  late double? deg;
  late double? gust;

  Wind({
    required this.speed,
    required this.deg,
    required this.gust,
  });

  Wind.fromMap(Map map) {
    this.speed = double.parse(map['speed'].toString());
    this.gust = double.parse(map['gust'].toString());
    this.deg = double.parse(map['deg'].toString());
  }

  Map toMap() {
    return {
      "speed": this.speed,
      "gust": this.gust,
      "deg": this.deg,
    };
  }
}
