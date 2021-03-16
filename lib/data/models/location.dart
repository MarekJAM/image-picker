class Location {
  final String city;
  final String country;
  final Position position;

  const Location({
    this.city,
    this.country,
    this.position,
  });

  factory Location.fromJson(Map<String, dynamic> data) => Location(
        city: data['city'],
        country: data['country'],
        position: Position.fromJson(data['position']),
      );
}

class Position {
  final String latitude;
  final String longitude;

  const Position({
    this.latitude,
    this.longitude,
  });

  factory Position.fromJson(Map<String, dynamic> data) => Position(
        latitude: data['latitude'],
        longitude: data['longitude'],
      );
}
