import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../models/photo.dart';
import '../../configurable/api_keys.dart';

class PhotosApiClient {
  static const baseUrl = 'https://api.unsplash.com';
  static const Map<String, String> headers = {
    "Authorization": "Client-ID ${ApiKeys.accessKey}"
  };
  static const pageSize = '30';

  final http.Client httpClient;

  PhotosApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Photo>> getPhotos() async {
    final searchImagesUrl = '$baseUrl/photos/?per_page=$pageSize';

    final response = await httpClient.get(searchImagesUrl, headers: headers);

    if (response.statusCode != 200) {
      throw Exception();
    }

    final data = jsonDecode(response.body) as List;

    return data.map((rawPhoto) {
      return Photo.fromJson(rawPhoto);
    }).toList();
  }

  Future<List<Photo>> searchPhotos({String query}) async {
    final searchImagesUrl = '$baseUrl/search/photos/?query=smoke&per_page=$pageSize';

    final response = await httpClient.get(searchImagesUrl, headers: headers);

    if (response.statusCode != 200) {
      throw Exception();
    }

    final data = jsonDecode(response.body)['results'] as List;

    return data.map((rawPhoto) {
      return Photo.fromJson(rawPhoto);
    }).toList();
  }
}
