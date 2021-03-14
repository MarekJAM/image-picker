import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../data/models/photo.dart';
import '../../data/repositories/photos_repository.dart';

part 'photos_event.dart';
part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final PhotosRepository photosRepository;

  PhotosBloc({@required this.photosRepository}) : super(PhotosInitial());

  @override
  Stream<PhotosState> mapEventToState(
    PhotosEvent event,
  ) async* {
    if (event is GetPhotos) {
      yield* _mapGetPhotosToState();
    }
    else if (event is SearchPhotos) {
      yield* _mapSearchPhotosToState(event);
    }
  }

  Stream<PhotosState> _mapGetPhotosToState() async* {
    yield PhotosLoading();
    try {
      final photos = await photosRepository.getPhotos();

      yield PhotosLoaded(photos: photos);
    } catch (e) {
      print(e);
      yield PhotosError(message: "Connection error occured.");
    }
  }

  Stream<PhotosState> _mapSearchPhotosToState(SearchPhotos event) async* {
    yield PhotosLoading();
    try {
      final photos = await photosRepository.searchPhotos(query: event.query);

      yield PhotosLoaded(photos: photos);
    } catch (e) {
      print(e);
      yield PhotosError(message: "Connection error occured.");
    }
  }
}
