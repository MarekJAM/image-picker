import 'package:flutter/foundation.dart';

class Photo {
  final String id;
  final String author;
  final String urlThumb;

  const Photo({
    @required this.id,
    @required this.author,
    @required this.urlThumb,
  });

  factory Photo.fromJson(Map<String, dynamic> data) => Photo(
        id: data['id'],
        author: data['user']['name'],
        urlThumb: data['urls']['small'],
      );
}
