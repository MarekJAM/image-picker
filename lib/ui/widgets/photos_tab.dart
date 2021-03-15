import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../bloc/photos/photos_bloc.dart';

class PhotosTab extends StatefulWidget {
  @override
  _PhotosTabState createState() => _PhotosTabState();
}

class _PhotosTabState extends State<PhotosTab> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Future<void> getPhotos({int page}) async {
    return BlocProvider.of<PhotosBloc>(context).add(GetPhotos(page: page));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotosBloc, PhotosState>(
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
                maxCrossAxisExtent: 100,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                staggeredTileCount: state.photos.length,
              ),
              controller: _scrollController,
              itemCount: state.photos.length,
              padding: EdgeInsets.only(top: 5, left: 5, right: 5),
              itemBuilder: (BuildContext context, int index) => Stack(
                children: [
                  Image.network(
                    state.photos[index].urlThumb,
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
                          state.photos[index].author,
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  size: 40,
                ),
                SizedBox(height: 10),
                Text('Something went wrong!', style: TextStyle(fontSize: 20),),
                SizedBox(height: 10),
                ElevatedButton(onPressed: () {
                  getPhotos();
                }, child: Text('Retry'))
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      BlocProvider.of<PhotosBloc>(context).add(GetPhotos());
    }
  }
}
