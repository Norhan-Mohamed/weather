class WeatherDescription {
  late int? id;
  late String? main;
  late String? description;
  late String? icon;
  WeatherDescription({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });
  WeatherDescription.fromMap(Map map) {
    this.id = map['id'];
    this.main = map['main'];
    this.description = map['description'];
    this.icon = map['icon'];
  }
  Map toMap() {
    return {
      "id": this.id,
      "main": this.main,
      "description": this.description,
      "icon": this.icon,
    };
  }
}
