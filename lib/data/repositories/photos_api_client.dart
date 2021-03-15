import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../models/photo.dart';
import '../../configurable/api_keys.dart';
import '../../configurable/api_config.dart';

class PhotosApiClient {
  static const baseUrl = 'https://api.unsplash.com';
  static const Map<String, String> headers = {
    "Authorization": "Client-ID ${ApiKeys.accessKey}"
  };

  final http.Client httpClient;

  PhotosApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Photo>> getPhotos({int page}) async {
    final url = '$baseUrl/photos/?per_page=${ApiConfig.pageSize}&page=${(page ?? 1)}';

    final response = await httpClient.get(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception();
    }

    final data = jsonDecode(response.body) as List;

    return data.map((rawPhoto) {
      return Photo.fromJson(rawPhoto);
    }).toList();
  }

  Future<List<Photo>> searchPhotos({String query, int page}) async {
    final url = '$baseUrl/search/photos/?query=$query&per_page=${ApiConfig.pageSize}&page=${(page ?? 1)}';

    final response = await httpClient.get(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception();
    }

    final data = jsonDecode(response.body)['results'] as List;

    return data.map((rawPhoto) {
      return Photo.fromJson(rawPhoto);
    }).toList();
  }
}
