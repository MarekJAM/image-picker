part of 'photo_details_bloc.dart';

@immutable
abstract class PhotoDetailsEvent {}

class GetPhoto extends PhotoDetailsEvent {
  final String id;

  GetPhoto({@required this.id});

  @override
  String toString() => 'GetPhoto, id: $id';
}

class FavoritePhotosUpdated extends PhotoDetailsEvent {
  final List<Photo> photos;

  FavoritePhotosUpdated({@required this.photos});

  @override
  String toString() => 'FavoritePhotosUpdated, photos: $photos';
}

