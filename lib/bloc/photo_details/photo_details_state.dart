part of 'photo_details_bloc.dart';

@immutable
abstract class PhotoDetailsState {
  const PhotoDetailsState();
}

class PhotoDetailsInitial extends PhotoDetailsState {}

class PhotoDetailsLoading extends PhotoDetailsState {}

class PhotoDetailsLoaded extends PhotoDetailsState {
  final Photo photo;

  const PhotoDetailsLoaded({@required this.photo});
  
  @override
  String toString() => 'PhotoDetailsLoaded: $photo';
}

class PhotoDetailsError extends PhotoDetailsState {
  final String message;

  PhotoDetailsError({this.message});

  @override
  String toString() => 'PhotoDetailsError, message: $message';
}
