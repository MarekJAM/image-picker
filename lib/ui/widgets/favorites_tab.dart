import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import 'package:intl/intl.dart';

import '../../data/repositories/photos_repository.dart';
import '../../ui/screens/photo_details_screen.dart';
import '../../bloc/blocs.dart';

class FavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritePhotosBloc, FavoritePhotosState>(
      builder: (context, state) {
        if (state is FavoritePhotosLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FavoritePhotosLoaded) {
          return state.photos.length > 0
              ? ListView.builder(
                  itemCount: state.photos.length,
                  itemBuilder: (context, i) => Dismissible(
                    key: Key(state.photos[i].id),
                    onDismissed: (dir) {
                      BlocProvider.of<FavoritePhotosBloc>(context).add(
                        RemovePhotoFromFavorites(id: state.photos[i].id),
                      );
                    },
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.cancel),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return BlocProvider(
                                create: (context) => PhotoDetailsBloc(
                                  photosRepository:
                                      RepositoryProvider.of<PhotosRepository>(context),
                                ),
                                child: PhotoDetailsScreen(
                                  id: state.photos[i].id,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: Card(
                        child: Container(
                          height: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Image.network(
                                  state.photos[i].url.thumb,
                                  fit: BoxFit.fitWidth,
                                  frameBuilder: (
                                    BuildContext context,
                                    Widget child,
                                    int frame,
                                    bool wasSynchronouslyLoaded,
                                  ) {
                                    return AnimatedCrossFade(
                                      firstChild: Container(
                                        height: 120,
                                        child: state.photos[i].blurHash != null
                                            ? BlurHash(
                                                hash: state.photos[i].blurHash,
                                                imageFit: BoxFit.fill,
                                              )
                                            : Container(),
                                      ),
                                      secondChild: Container(
                                        width: double.infinity,
                                        child: child,
                                      ),
                                      duration: const Duration(milliseconds: 500),
                                      crossFadeState: frame == null
                                          ? CrossFadeState.showFirst
                                          : CrossFadeState.showSecond,
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.photos[i].user.name,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          'Created: ${DateFormat('yyyy-MM-dd').format(state.photos[i].createdAt)}'),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      if (state.photos[i].description != null)
                                        Expanded(
                                          child: Text(
                                            state.photos[i].description,
                                            overflow: TextOverflow.fade,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text('There are no favorite photos yet!'),
                );
        }
        return Container();
      },
    );
  }
}
