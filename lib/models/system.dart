class System {
  final String? pod;

  const System({this.pod});

  factory System.fromMap(Map<String, dynamic> map) {
    return System(pod: map['pod'] as String?);
  }

  Map<String, dynamic> toMap() => {'pod': pod};
}
