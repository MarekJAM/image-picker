part of 'favorite_photos_bloc.dart';

@immutable
abstract class FavoritePhotosEvent {}

class GetFavoritePhotos extends FavoritePhotosEvent {
  final String query;

  GetFavoritePhotos({this.query});

  @override
  String toString() => 'GetPhoto, id: $query';
}

class AddPhotoToFavorites extends FavoritePhotosEvent {
  final Photo photo;

  AddPhotoToFavorites({this.photo});

  @override
  String toString() => 'AddPhotoToFavorites, photo: $photo';
}

class RemovePhotoFromFavorites extends FavoritePhotosEvent {
  final String id;

  RemovePhotoFromFavorites({@required this.id});

  @override
  String toString() => 'RemovePhotoFromFavorites, id: $id';
}
