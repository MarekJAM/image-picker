part of 'photos_bloc.dart';

@immutable
abstract class PhotosEvent {}

class GetPhotos extends PhotosEvent {
  final int page;

  GetPhotos({this.page});

  @override
  String toString() => 'GetPhotos, page $page';
}

class SearchPhotos extends PhotosEvent {
  final String query;

  SearchPhotos({this.query});

  @override
  String toString() => 'GetPhotos $query';
}
