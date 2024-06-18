class Asteroid {
  final String name;
  final bool isHazardous;
  bool checked;

  Asteroid({
    required this.name,
    required this.isHazardous,
    this.checked = false,
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
     bool? checked,
  }) {
    return Asteroid(
      name: name ?? this.name,
      isHazardous: isHazardous ?? this.isHazardous,
      checked: checked ?? this.checked,
    );
  }

  @override
  String toString() => 'Asteroid(name: $name, isHazardous: $isHazardous, checked: $checked)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Asteroid &&
      other.name == name &&
      other.isHazardous == isHazardous &&
      other.checked == checked;
  }

  @override
  int get hashCode => name.hashCode ^ isHazardous.hashCode ^ checked.hashCode;
}
