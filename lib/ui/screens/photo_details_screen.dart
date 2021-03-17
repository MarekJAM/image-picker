import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/photo_details/photo_details_bloc.dart';
import '../../data/models/photo.dart';

class PhotoDetailsScreen extends StatefulWidget {
  final String id;

  PhotoDetailsScreen({@required this.id});

  @override
  _PhotoDetailsScreenState createState() => _PhotoDetailsScreenState();
}

class _PhotoDetailsScreenState extends State<PhotoDetailsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PhotoDetailsBloc>(context).add(GetPhoto(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<PhotoDetailsBloc, PhotoDetailsState>(
              builder: (context, state) {
                if (state is PhotoDetailsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is PhotoDetailsLoaded) {
                  return Column(
                    children: [
                      Container(
                        height: mediaQuery.size.height * 0.3,
                        width: double.infinity,
                        child: Image.network(
                          state.photo.url.regular,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      _buildMainInfoArea(state.photo),
                      Divider()
                    ],
                  );
                }
                return Container();
              },
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 40,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfoArea(Photo photo) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Text(photo.user.name),
                if (photo.description != null)
                  Text(
                    photo.description,
                    softWrap: true,
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd').format(photo.createdAt),
                ),
                if (photo.location != null)
                  Text(
                    '${photo.location.city ?? ''} ${photo.location.country}',
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
