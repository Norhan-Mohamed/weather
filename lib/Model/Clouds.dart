class Clouds {
  late int? all;

  Clouds({required this.all});

  Clouds.fromMap(Map map) {
    this.all = int.parse(map['all'].toString());
  }
  Map toMap() {
    return {'all': this.all};
  }
}
