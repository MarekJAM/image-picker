part of 'photos_bloc.dart';

@immutable
abstract class PhotosState {
  const PhotosState();
}

class PhotosInitial extends PhotosState {}

class PhotosLoading extends PhotosState {}

class PhotosLoaded extends PhotosState {
  final List<Photo> photos;
  final bool hasReachedLastPage;

  const PhotosLoaded({@required this.photos, this.hasReachedLastPage});

  PhotosLoaded copyWith({
    List<Photo> photos,
    bool hasReachedLastPage,
  }) {
    return PhotosLoaded(
      photos: photos ?? this.photos,
      hasReachedLastPage: hasReachedLastPage ?? this.hasReachedLastPage,
    );
  }

  @override
  String toString() => 'PhotosLoaded, amount: ${photos.length}';
}

class PhotosError extends PhotosState {
  final String message;

  PhotosError({this.message});

  @override
  String toString() => 'PhotosError, message: $message';
}
