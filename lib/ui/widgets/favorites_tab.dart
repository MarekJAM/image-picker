import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/photos/photos_bloc.dart';

class FavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotosBloc, PhotosState>(
      builder: (context, state) {
        if (state is PhotosLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PhotosLoaded) {
          return ListView.builder(
            itemCount: state.photos.length,
            itemBuilder: (context, i) => Card(
              child: Container(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Image.network(
                        state.photos[i].url.thumb,
                        fit: BoxFit.fitWidth,
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
          );
        }
        return Container();
      },
    );
  }
}
