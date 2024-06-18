class Asteroid {
  final String name;
  final bool isHazardous;

  const Asteroid({
    required this.name,
    required this.isHazardous,
  });

  factory Asteroid.fromMap(Map<String, dynamic> mapData) {
    return Asteroid(
      name: mapData['name'] ?? '',
      isHazardous: mapData['is_potentially_hazardous_asteroid'] ?? false,
    );
  }

  Asteroid copyWith({
    String? name,
    bool? isHazardous,
  }) {
    return Asteroid(
      name: name ?? this.name,
      isHazardous: isHazardous ?? this.isHazardous,
    );
  }

  @override
  String toString() => 'Asteroid(name: $name, isHazardous: $isHazardous)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Asteroid &&
        other.name == name &&
        other.isHazardous == isHazardous;
  }

  @override
  int get hashCode => name.hashCode ^ isHazardous.hashCode;
}
