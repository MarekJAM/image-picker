import 'dart:async';

import 'package:meta/meta.dart';

import '../models/photo.dart';
import 'photos_api_client.dart';

class PhotosRepository {
  final PhotosApiClient photosApiClient;

  PhotosRepository({@required this.photosApiClient})
      : assert(photosApiClient != null);

  Future<List<Photo>> getPhotos({int page}) async {
    return await photosApiClient.getPhotos(page: page);
  }

  Future<List<Photo>> searchPhotos({String query, int page}) async {
    return await photosApiClient.searchPhotos(query: query, page: page);
  }
}
