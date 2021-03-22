part of 'favorite_photos_bloc.dart';

@immutable
abstract class FavoritePhotosState {
  const FavoritePhotosState();
}

class FavoritePhotosInitial extends FavoritePhotosState {}

class FavoritePhotosLoading extends FavoritePhotosState {}

class FavoritePhotosLoaded extends FavoritePhotosState {
  final List<Photo> photos;

  const FavoritePhotosLoaded({@required this.photos});

  @override
  String toString() => 'FavoritePhotosLoaded';
}

class FavoritePhotosError extends FavoritePhotosState {
  final String message;

  const FavoritePhotosError({this.message});

  @override
  String toString() => 'FavoritePhotosError, message: $message';
}
