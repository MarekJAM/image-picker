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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => photosRepository,
        ),
        RepositoryProvider(
          create: (context) => favoritePhotosRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PhotosBloc(
              photosRepository: photosRepository,
            ),
          ),
          BlocProvider(
            create: (context) => FavoritePhotosBloc(
              favoritePhotosRepository: favoritePhotosRepository,
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Image Picker',
          theme: ThemeData(
            brightness: Brightness.dark,
            accentColor: Color(0xffff7844),
            scaffoldBackgroundColor: Color(0xff414141),
            cardColor: Color(0xff525252),
            buttonTheme: ButtonThemeData(buttonColor: Color(0xffF34213)),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color(0xffF34213),
                ),
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Color(0xff313131),
              selectedIconTheme: IconThemeData(
                color: Color(0xffff7844),
              ),
            ),
          ),
          home: MainScreen(title: 'Image Picker'),
        ),
      ),
    );
  }
}
