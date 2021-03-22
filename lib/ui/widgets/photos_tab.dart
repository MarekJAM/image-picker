import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../bloc/blocs.dart';
import '../../data/repositories/repositories.dart';
import '../../bloc/photo_details/photo_details_bloc.dart';
import '../../data/repositories/photos_repository.dart';
import '../../ui/screens/photo_details_screen.dart';
import '../../bloc/photos/photos_bloc.dart';
import 'widgets.dart';

class PhotosTab extends StatefulWidget {
  @override
  _PhotosTabState createState() => _PhotosTabState();
}

class _PhotosTabState extends State<PhotosTab> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  final _searchController = TextEditingController();
  var _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchQuery = _searchController.text;
                    getPhotos(page: 1);
                  },
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    _searchController.clear();
                    _searchQuery = '';
                  },
                ),
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.0),
                ),
              ),
              onSubmitted: (value) {
                _searchQuery = value;
                getPhotos(page: 1);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<PhotosBloc, PhotosState>(
              builder: (context, state) {
                if (state is PhotosLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PhotosLoaded) {
                  return RefreshIndicator(
                    onRefresh: () => getPhotos(page: 1),
                    child: StaggeredGridView.builder(
                      gridDelegate: SliverStaggeredGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: mediaQuery.size.width / (mediaQuery.orientation == Orientation.landscape ? 4 : 2),
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                        staggeredTileCount: state.photos.length,
                      ),
                      controller: _scrollController,
                      itemCount: state.photos.length,
                      itemBuilder: (BuildContext context, int index) => Stack(
                        children: [
                          GestureDetector(
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
                                            RepositoryProvider.of<FavoritePhotosRepository>(
                                                context),
                                        favoritePhotosBloc:
                                            BlocProvider.of<FavoritePhotosBloc>(context),
                                      ),
                                      child: PhotoDetailsScreen(
                                        id: state.photos[index].id,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Image.network(
                              state.photos[index].url.thumb,
                              fit: BoxFit.fitWidth,
                              errorBuilder: (context, exception, stackTrace) {
                                return Container(
                                  color: Colors.black38,
                                  height: 120,
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Icon(Icons.broken_image), Text('Image unavailable')],
                                  ),
                                );
                              },
                              frameBuilder: (
                                BuildContext context,
                                Widget child,
                                int frame,
                                bool wasSynchronouslyLoaded,
                              ) {
                                return AnimatedCrossFade(
                                  firstChild: AspectRatio(
                                    aspectRatio:
                                        state.photos[index].width / state.photos[index].height,
                                    child: state.photos[index].blurHash != null
                                        ? BlurHash(
                                            hash: state.photos[index].blurHash,
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
                          Positioned(
                            bottom: 3,
                            left: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[700].withOpacity(0.5),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                child: Text(
                                  state.photos[index].user.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is PhotosError) {
                  return CenterErrorInfo(
                    onButtonPressed: getPhotos,
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getPhotos({int page}) async {
    return BlocProvider.of<PhotosBloc>(context).add(GetPhotos(page: page, query: _searchQuery));
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      getPhotos();
    }
  }
}
