import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import 'package:intl/intl.dart';

import '../../data/repositories/favorite_photos_repository.dart';
import '../../data/repositories/photos_repository.dart';
import '../../ui/screens/photo_details_screen.dart';
import '../../bloc/blocs.dart';

class FavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return BlocBuilder<FavoritePhotosBloc, FavoritePhotosState>(
      builder: (context, state) {
        if (state is FavoritePhotosLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FavoritePhotosLoaded) {
          return state.photos.length > 0
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3,
                      crossAxisCount: mediaQuery.orientation == Orientation.landscape ? 2 : 1),
                  itemCount: state.photos.length,
                  itemBuilder: (context, i) => Dismissible(
                    key: Key(state.photos[i].id),
                    onDismissed: (_) {
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
                                  favoritePhotosRepository:
                                      RepositoryProvider.of<FavoritePhotosRepository>(context),
                                  favoritePhotosBloc: BlocProvider.of<FavoritePhotosBloc>(context),
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
                                  padding:
                                      const EdgeInsets.only(top: 6, right: 4, bottom: 4, left: 6),
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
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                              '${DateFormat('yyyy-MM-dd').format(state.photos[i].createdAt)}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          state.photos[i].description ??
                                              state.photos[i].altDescription ??
                                              '',
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      )
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
