part of 'photo_details_bloc.dart';

@immutable
abstract class PhotoDetailsState {
  const PhotoDetailsState();
}

class PhotoDetailsInitial extends PhotoDetailsState {}

class PhotoDetailsLoading extends PhotoDetailsState {}

class PhotoDetailsLoaded extends PhotoDetailsState {
  final Photo photo;
  final bool isFavorite;

  const PhotoDetailsLoaded({@required this.photo, @required this.isFavorite});

  PhotoDetailsLoaded copyWith({
    List<Photo> photos,
    bool isFavorite,
  }) {
    return PhotoDetailsLoaded(
      photo: photo ?? this.photo,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() => 'PhotoDetailsLoaded: $photo';
}

class PhotoDetailsError extends PhotoDetailsState {
  final String message;

  const PhotoDetailsError({this.message});

  @override
  String toString() => 'PhotoDetailsError, message: $message';
}
