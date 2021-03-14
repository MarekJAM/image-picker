part of 'photos_bloc.dart';

@immutable
abstract class PhotosEvent {}

class GetPhotos extends PhotosEvent {
  @override
  String toString() => 'GetPhotos';
}

class SearchPhotos extends PhotosEvent {
  final String query;

  SearchPhotos({this.query});

  @override
  String toString() => 'GetPhotos $query';
}
