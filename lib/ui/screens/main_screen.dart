import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../bloc/photos/photos_bloc.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PhotosBloc>(context).add(GetPhotos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder<PhotosBloc, PhotosState>(
        builder: (context, state) {
          if (state is PhotosLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PhotosLoaded) {
            return StaggeredGridView.builder(
              gridDelegate: SliverStaggeredGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                staggeredTileCount: state.photos.length,
              ),
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
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
