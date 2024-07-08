class Location {
  final int? id;
  final double latitude;
  final double longitude;

  Location({this.id, required this.latitude, required this.longitude});

  // Existing toMap method
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Implementing fromJson constructor
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  // Implementing copy method
  Location copy({int? id, double? latitude, double? longitude}) {
    return Location(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() {
    return 'Location{id: $id, latitude: $latitude, longitude: $longitude}';
  }
}