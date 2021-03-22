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
    this.createdAt,
    this.height,
    this.width,
    this.blurHash,
    this.description,
    this.user,
    this.url,
    this.exif,
    this.location,
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

  factory Photo.fromDb(Map<String, dynamic> data) => Photo(
    id: data['photo_id'],
    createdAt: DateTime.parse(data['created_at']),
    user: User(name: data['user_name']),
    description: data['description'],
    blurHash: data['blur_hash'],
    url: Url(thumb: data['thumb_url']),
  );

  Map<String, dynamic> toMap() => {
    "photo_id": id,
    "user_name": user.name,
    "created_at": createdAt.toIso8601String(),
    "description": description,
    "thumb_url": url.thumb,
    "blur_hash": blurHash,
  };
}
