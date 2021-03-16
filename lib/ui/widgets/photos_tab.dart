import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
                      gridDelegate:
                          SliverStaggeredGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 100,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.fit(2),
                        staggeredTileCount: state.photos.length,
                      ),
                      controller: _scrollController,
                      itemCount: state.photos.length,
                      itemBuilder: (BuildContext context, int index) => Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              print(state.photos[index].blurHash);
                            },
                            child: Image.network(
                              state.photos[index].url.thumb,
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
    return BlocProvider.of<PhotosBloc>(context)
        .add(GetPhotos(page: page, query: _searchQuery));
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      getPhotos();
    }
  }
}

