import 'dart:async';

import 'package:flutter/foundation.dart';

import 'database.dart';
import '../models/photo.dart';

class FavoritePhotosDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> insertFavoritePhoto({@required Photo photo}) async {
    final db = await dbProvider.database;
    var result = await db.insert(favoritePhotosTable, photo.toMap());

    return result;
  }

  Future<List<Photo>> getFavoritePhotos({
    List<String> columns,
    String query,
  }) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(favoritePhotosTable,
            columns: columns, where: 'user_name LIKE ?', whereArgs: ["%$query%"]);
    } else {
      result = await db.query(favoritePhotosTable, columns: columns);
    }

    List<Photo> photos = result.isNotEmpty ? result.map((item) => Photo.fromDb(item)).toList() : [];
    return photos;
  }

  Future<int> updateFavoritePhoto({@required Photo photo}) async {
    final db = await dbProvider.database;

    var result = await db
        .update(favoritePhotosTable, photo.toMap(), where: "photo_id = ?", whereArgs: [photo.id]);

    return result;
  }

  Future<int> deleteFavoritePhoto({@required String id}) async {
    final db = await dbProvider.database;
    var result = await db.delete(favoritePhotosTable, where: 'photo_id = ?', whereArgs: [id]);

    return result;
  }

  Future<bool> isPhotoFavorite({
    String id,
  }) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    result = await db.query(favoritePhotosTable, where: 'photo_id = ?', whereArgs: [id]);

    return result.length > 0;
  }
}
