class Wind {
  final double? speed;
  final double? deg;
  final double? gust;

  const Wind({this.speed, this.deg, this.gust});

  factory Wind.fromMap(Map<String, dynamic> map) {
    return Wind(
      speed: (map['speed'] as num?)?.toDouble(),
      deg: (map['deg'] as num?)?.toDouble(),
      gust: (map['gust'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'speed': speed,
        'deg': deg,
        'gust': gust,
      };
}
