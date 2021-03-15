import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/models/photo.dart';
import '../../data/repositories/photos_repository.dart';
import '../../configurable/api_config.dart';

part 'photos_event.dart';
part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final PhotosRepository photosRepository;

  PhotosBloc({@required this.photosRepository}) : super(PhotosInitial());

  @override
  Stream<Transition<PhotosEvent, PhotosState>> transformEvents(
    Stream<PhotosEvent> events,
    TransitionFunction<PhotosEvent, PhotosState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<PhotosState> mapEventToState(
    PhotosEvent event,
  ) async* {
    if (event is GetPhotos) {
      yield* _mapGetPhotosToState(event);
    } else if (event is SearchPhotos) {
      yield* _mapSearchPhotosToState(event);
    }
  }

  Stream<PhotosState> _mapGetPhotosToState(GetPhotos event) async* {
    final currentState = state;

    try {
      if (currentState is PhotosInitial || state is PhotosError || event.page != null) {
        yield PhotosLoading();

        final photos = await photosRepository.getPhotos(page: 1);

        yield PhotosLoaded(photos: photos);
      } else if (!_hasReachedLastPage(currentState) && currentState is PhotosLoaded) {
        final photos = await photosRepository.getPhotos(
          page: _nextPage(currentState),
        );

        yield (photos.isEmpty)
            ? currentState.copyWith(hasReachedLastPage: true)
            : PhotosLoaded(
                photos: currentState.photos + photos,
              );
      }
    } catch (e) {
      print(e);
      yield PhotosError(message: "Connection error occured.");
    }
  }

  Stream<PhotosState> _mapSearchPhotosToState(SearchPhotos event) async* {
    yield PhotosLoading();
    try {
      final photos = await photosRepository.searchPhotos(
        query: event.query,
        page: 1,
      );

      yield PhotosLoaded(photos: photos);
    } catch (e) {
      print(e);
      yield PhotosError(message: "Connection error occured.");
    }
  }

  int _nextPage(PhotosLoaded state) =>
      (state.photos.length ~/ ApiConfig.pageSize) + 1;

  bool _hasReachedLastPage(PhotosState state) =>
      state is PhotosLoaded && (state.hasReachedLastPage ?? false);
}
