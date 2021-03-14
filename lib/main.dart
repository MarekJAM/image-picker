import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/bloc/photos/photos_bloc.dart';
import 'package:image_picker/data/repositories/photos_api_client.dart';

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

  runApp(
    App(
      photosRepository: photosRepository,
    ),
  );
}

class App extends StatelessWidget {
  final PhotosRepository photosRepository;

  App({@required this.photosRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PhotosBloc(photosRepository: photosRepository),
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
    );
  }
}
