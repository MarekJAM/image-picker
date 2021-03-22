import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/photo.dart';
import '../../data/repositories/repositories.dart';
import '../../bloc/blocs.dart';

part 'photo_details_event.dart';
part 'photo_details_state.dart';

class PhotoDetailsBloc extends Bloc<PhotoDetailsEvent, PhotoDetailsState> {
  final PhotosRepository photosRepository;
  final FavoritePhotosRepository favoritePhotosRepository;
  final FavoritePhotosBloc favoritePhotosBloc;
  StreamSubscription favoritePhotosSubscription;

  PhotoDetailsBloc({
    @required this.photosRepository,
    @required this.favoritePhotosRepository,
    @required this.favoritePhotosBloc,
  }) : super(PhotoDetailsInitial()) {
    favoritePhotosSubscription = favoritePhotosBloc.listen((state) {
      if (state is FavoritePhotosLoaded) {
        add(FavoritePhotosUpdated(photos: state.photos));
      }
    });
  }

  @override
  Stream<PhotoDetailsState> mapEventToState(
    PhotoDetailsEvent event,
  ) async* {
    if (event is GetPhoto) {
      yield* _mapGetPhotoToState(event);
    } else if (event is FavoritePhotosUpdated) {
      yield* _mapFavoritePhotosUpdatedToState(event);
    }
  }

  Stream<PhotoDetailsState> _mapGetPhotoToState(GetPhoto event) async* {
    yield PhotoDetailsLoading();

    try {
      final photo = await photosRepository.getPhoto(
        id: event.id,
      );

      final isFavorite = await favoritePhotosRepository.isPhotoFavorite(id: event.id);

      yield PhotoDetailsLoaded(photo: photo, isFavorite: isFavorite);
    } catch (e) {
      print(e);
      yield PhotoDetailsError(message: "Connection error occured.");
    }
  }

  Stream<PhotoDetailsState> _mapFavoritePhotosUpdatedToState(FavoritePhotosUpdated event) async* {
    final currentState = state;

    if (currentState is PhotoDetailsLoaded) {
      final isFavorite = ((event.photos
              .singleWhere((photo) => photo.id == currentState.photo.id, orElse: () => null)) !=
          null);

      yield currentState.copyWith(isFavorite: isFavorite);
    }
  }

  @override
  Future<void> close() {
    favoritePhotosSubscription.cancel();
    return super.close();
  }
}
