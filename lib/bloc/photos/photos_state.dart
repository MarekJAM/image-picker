part of 'photos_bloc.dart';

@immutable
abstract class PhotosState {}

class PhotosInitial extends PhotosState {}

class PhotosLoading extends PhotosState {}

class PhotosLoaded extends PhotosState {
  final List<Photo> photos;

  PhotosLoaded({@required this.photos});

  @override
  String toString() => 'PhotosLoaded, amount: ${photos.length}';
}

class PhotosError extends PhotosState {
  final String message;

  PhotosError({this.message});

  @override
  String toString() => 'PhotosError';
}