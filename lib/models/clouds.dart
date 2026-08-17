class Clouds {
  final int? all;

  const Clouds({this.all});

  factory Clouds.fromMap(Map<String, dynamic> map) {
    return Clouds(all: (map['all'] as num?)?.toInt());
  }

  Map<String, dynamic> toMap() => {'all': all};
}
