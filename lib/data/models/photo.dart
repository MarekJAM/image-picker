import 'package:flutter/foundation.dart';

import 'models.dart';

class Photo {
  final String id;
  final DateTime createdAt;
  final int height;
  final int width;
  final String blurHash;
  final String description;
  final User user;
  final Url url;
  final Exif exif;
  final Location location;

  const Photo({
    @required this.id,
    @required this.createdAt,
    @required this.height,
    @required this.width,
    @required this.blurHash,
    @required this.description,
    @required this.user,
    @required this.url,
    @required this.exif,
    @required this.location,
  });

  factory Photo.fromJson(Map<String, dynamic> data) => Photo(
        id: data['id'],
        createdAt: DateTime.parse(data['created_at']),
        height: data['height'],
        width: data['width'],
        blurHash: data['blur_hash'],
        description: data['description'],
        user: data['user'] != null ? User.fromJson(data['user']) : null,
        url: data['urls'] != null ? Url.fromJson(data['urls']) : null,
        exif: data['exif'] != null ? Exif.fromJson(data['exif']) : null,
        location: data['location'] != null ? Location.fromJson(data['location']) : null,
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user": user?.name,
    "createdAt": createdAt.toIso8601String(),
    "description": description,
    "thumbUrl": url?.thumb,
  };
}
