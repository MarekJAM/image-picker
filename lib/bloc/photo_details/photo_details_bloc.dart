import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/photo.dart';
import '../../data/repositories/photos_repository.dart';

part 'photo_details_event.dart';
part 'photo_details_state.dart';

class PhotoDetailsBloc extends Bloc<PhotoDetailsEvent, PhotoDetailsState> {
  final PhotosRepository photosRepository;

  PhotoDetailsBloc({@required this.photosRepository})
      : super(PhotoDetailsInitial());

  @override
  Stream<PhotoDetailsState> mapEventToState(
    PhotoDetailsEvent event,
  ) async* {
    if (event is GetPhoto) {
      yield* _mapGetPhotoToState(event);
    }
  }

  Stream<PhotoDetailsState> _mapGetPhotoToState(GetPhoto event) async* {
    yield PhotoDetailsLoading();

    try {
      final photo = await photosRepository.getPhoto(
        id: event.id,
      );

      yield PhotoDetailsLoaded(photo: photo);
    } catch (e) {
      print(e);
      yield PhotoDetailsError(message: "Connection error occured.");
    }
  }
}
