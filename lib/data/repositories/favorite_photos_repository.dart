import 'dart:async';

import 'package:meta/meta.dart';

import '../models/photo.dart';
import 'favorite_photo_dao.dart';

class FavoritePhotosRepository {
  final FavoritePhotosDao favoritePhotosDao;

  FavoritePhotosRepository({@required this.favoritePhotosDao}) : assert(favoritePhotosDao != null);

  Future<List<Photo>> getFavoritePhotos({String query}) async {
    return await favoritePhotosDao.getFavoritePhotos(query: query);
  }

  Future<int> addToFavorites({@required Photo photo}) async {
    return await favoritePhotosDao.insertFavoritePhoto(photo: photo);
  }

  Future<int> updateFavoritePhoto({@required Photo photo}) async {
    return await favoritePhotosDao.deleteFavoritePhoto(id: photo.id);
  }

  Future<int> removePhotoFromFavorites({@required id}) async {
    return await favoritePhotosDao.deleteFavoritePhoto(id: id);
  }
}
