import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../configurable/asset_paths.dart';
import '../../bloc/blocs.dart';
import '../../data/models/models.dart';
import '../widgets/photo_details/photo_details_widgets.dart';
import '../widgets/common/center_error_info.dart';

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
                  final maxExtent = mediaQuery.size.width * (state.photo.height / state.photo.width);
                  return CustomScrollView(
                    slivers: [
                      SliverPersistentHeader(
                        pinned: true,
                        floating: true,
                        delegate: SliverHeader(
                          photo: state.photo,
                          isFavorite: state.isFavorite,
                          minExtent: 100,
                          maxExtent: maxExtent > mediaQuery.size.height - 100 ? mediaQuery.size.height - 100 : maxExtent,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            _buildMainInfoArea(state.photo),
                            if (state.photo.exif.isAnyFieldNotNull())
                              ContentArea(_buildExifArea(state.photo.exif)),
                            if (state.photo.user.isAnyFieldNotNull())
                              ContentArea(_buildUserInfoArea(state.photo.user)),
                          ],
                        ),
                      )
                      // SliverFillRemaining(),
                    ],
                  );
                }
                if (state is PhotoDetailsError) {
                  return CenterErrorInfo(
                    onButtonPressed: () {
                      BlocProvider.of<PhotoDetailsBloc>(context).add(
                        GetPhoto(id: widget.id),
                      );
                    },
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfoArea(Photo photo) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('yyyy-MM-dd').format(photo.createdAt),
              ),
              if (photo.location != null)
                Text(
                  '${photo.location.city ?? ''} ${photo.location.country ?? ''}',
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              photo.user.name,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          if (photo.description != null)
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                photo.description,
                softWrap: true,
              ),
            )
        ],
      ),
    );
  }

  Widget _buildExifArea(Exif exif) {
    return Column(
      children: [
        TextDataRow(title: 'Make', value: exif.make),
        TextDataRow(title: 'Model', value: exif.model),
        TextDataRow(title: 'Exposure time', value: exif.expoosureTime),
        TextDataRow(title: 'Aperture', value: exif.aperture),
        TextDataRow(title: 'Focal length', value: exif.focalLength),
        TextDataRow(title: 'ISO', value: exif.iso),
      ],
    );
  }

  Widget _buildUserInfoArea(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextDataRow(title: 'Username', value: user.username),
        TextDataRow(title: 'Portfolio', value: user.portfolioUrl),
        if (user.twitterUsername != null || user.instagramUsername != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Social media'),
              Wrap(
                children: [
                  if (user.instagramUsername != null) SocialMediaIconArea(AssetPaths.instagramLogo),
                  if (user.twitterUsername != null) SocialMediaIconArea(AssetPaths.twitterLogo),
                ],
              )
            ],
          ),
      ],
    );
  }
}