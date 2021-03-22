import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/photo.dart';
import '../../data/repositories/repositories.dart';

part 'favorite_photos_event.dart';
part 'favorite_photos_state.dart';

class FavoritePhotosBloc extends Bloc<FavoritePhotosEvent, FavoritePhotosState> {
  final FavoritePhotosRepository favoritePhotosRepository;

  FavoritePhotosBloc({@required this.favoritePhotosRepository}) : super(FavoritePhotosInitial());

  @override
  Stream<FavoritePhotosState> mapEventToState(
    FavoritePhotosEvent event,
  ) async* {
    if (event is GetFavoritePhotos) {
      yield* _mapGetFavoritePhotosToState(event);
    } else if (event is AddPhotoToFavorites) {
      yield* _mapAddPhotoToFavoritesToState(event);
    } else if (event is RemovePhotoFromFavorites) {
      yield* _mapRemovePhotoFromFavoritesToState(event);
    }
  }

  Stream<FavoritePhotosState> _mapGetFavoritePhotosToState(GetFavoritePhotos event) async* {
    yield FavoritePhotosLoading();

    try {
      final photos = await favoritePhotosRepository.getFavoritePhotos(query: event.query);

      yield FavoritePhotosLoaded(photos: photos);
    } catch (e) {
      print(e);
      yield FavoritePhotosError(message: "Error while loading favorite photos.");
    }
  }

  Stream<FavoritePhotosState> _mapAddPhotoToFavoritesToState(AddPhotoToFavorites event) async* {
    if (state is FavoritePhotosLoaded) {
      try {
        final result = await favoritePhotosRepository.addToFavorites(
          photo: event.photo,
        );

        if (result > 0) {
          final List<Photo> updatedPhotos = List.from((state as FavoritePhotosLoaded).photos)
            ..insert(0, event.photo);

          yield FavoritePhotosLoaded(photos: updatedPhotos);
        }
      } catch (e) {
        print(e);
        yield FavoritePhotosError(message: "Error while loading favorite photos.");
      }
    }
  }

  Stream<FavoritePhotosState> _mapRemovePhotoFromFavoritesToState(
      RemovePhotoFromFavorites event) async* {
    if (state is FavoritePhotosLoaded) {
      try {
        final result = await favoritePhotosRepository.removePhotoFromFavorites(
          id: event.id,
        );

        if (result > 0) {
          final List<Photo> updatedPhotos = (state as FavoritePhotosLoaded).photos
            ..removeWhere((photo) => photo.id == event.id);

          yield FavoritePhotosLoaded(photos: updatedPhotos);
        }
      } catch (e) {
        print(e);
        yield FavoritePhotosError(message: "Error while loading favorite photos.");
      }
    }
  }
}
