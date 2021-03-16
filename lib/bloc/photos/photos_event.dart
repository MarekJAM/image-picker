part of 'photos_bloc.dart';

@immutable
abstract class PhotosEvent {}

class GetPhotos extends PhotosEvent {
  final int page;
  final String query;

  GetPhotos({this.page, this.query = ''});

  @override
  String toString() => 'GetPhotos, page $page, query $query';
}