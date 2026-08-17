class WeatherDescription {
  final int? id;
  final String? main;
  final String? description;
  final String? icon;

  const WeatherDescription({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  factory WeatherDescription.fromMap(Map<String, dynamic> map) {
    return WeatherDescription(
      id: map['id'] as int?,
      main: map['main'] as String?,
      description: map['description'] as String?,
      icon: map['icon'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'main': main,
        'description': description,
        'icon': icon,
      };
}
