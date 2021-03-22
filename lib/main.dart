import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/blocs.dart';
import 'data/repositories/favorite_photo_dao.dart';
import 'data/repositories/photos_api_client.dart';

import 'ui/screens/screens.dart';
import 'bloc/simple_bloc_observer.dart';
import 'data/repositories/repositories.dart';

void main() {
  if (kDebugMode) {
    Bloc.observer = SimpleBlocObserver();
  }

  final photosRepository = PhotosRepository(
    photosApiClient: PhotosApiClient(
      httpClient: http.Client(),
    ),
  );

  final favoritePhotosRepository = FavoritePhotosRepository(
    favoritePhotosDao: FavoritePhotosDao(),
  );

  runApp(
    App(
      photosRepository: photosRepository,
      favoritePhotosRepository: favoritePhotosRepository,
    ),
  );
}

class App extends StatelessWidget {
  final PhotosRepository photosRepository;
  final FavoritePhotosRepository favoritePhotosRepository;

  App({
    @required this.photosRepository,
    @required this.favoritePhotosRepository,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => photosRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PhotosBloc(photosRepository: photosRepository),
          ),
          BlocProvider(
            create: (context) => FavoritePhotosBloc(favoritePhotosRepository: favoritePhotosRepository),
          ),
        ],
        child: MaterialApp(
          title: 'Image Picker',
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
          ),
          home: MainScreen(title: 'Image Picker'),
        ),
      ),
    );
  }
}
