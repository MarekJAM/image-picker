import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:intl/intl.dart';

import '../../configurable/asset_paths.dart';
import '../../bloc/photo_details/photo_details_bloc.dart';
import '../../data/models/models.dart';

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
        child: BlocBuilder<PhotoDetailsBloc, PhotoDetailsState>(
          builder: (context, state) {
            if (state is PhotoDetailsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is PhotoDetailsLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: SliverHeader(
                      photo: state.photo,
                      minExtent: 100,
                      maxExtent: mediaQuery.size.width *
                          (state.photo.height / state.photo.width),
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
            return Container();
          },
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
                  if (user.instagramUsername != null)
                    SocialMediaIcon(AssetPaths.instagramLogo),
                  if (user.twitterUsername != null)
                    SocialMediaIcon(AssetPaths.twitterLogo),
                ],
              )
            ],
          ),
      ],
    );
  }
}

class ContentArea extends StatelessWidget {
  final Widget content;

  ContentArea(this.content);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Padding(
          padding: EdgeInsets.all(8),
          child: content,
        ),
      ],
    );
  }
}

class SocialMediaIcon extends StatelessWidget {
  final String path;

  SocialMediaIcon(this.path);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Container(
        height: 15,
        child: Image.asset(path),
      ),
    );
  }
}

class TextDataRow extends StatelessWidget {
  final String title;
  final dynamic value;

  TextDataRow({@required this.title, @required this.value});

  @override
  Widget build(BuildContext context) {
    return value != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Text(title),
              ),
              Expanded(
                child: Text(
                  '$value',
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          )
        : Container();
  }
}

class SliverHeader extends SliverPersistentHeaderDelegate {
  final Photo photo;
  final double minExtent;
  final double maxExtent;
  SliverHeader({
    @required this.photo,
    this.minExtent,
    @required this.maxExtent,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: Image.network(
            photo.url.regular,
            fit: BoxFit.fitWidth,
            frameBuilder: (
              BuildContext context,
              Widget child,
              int frame,
              bool wasSynchronouslyLoaded,
            ) {
              return AnimatedCrossFade(
                firstChild: Container(
                  height: maxExtent,
                  child: photo.blurHash != null ? BlurHash(hash: photo.blurHash) : Container(),
                ),
                secondChild: Container(width: double.infinity, child: child),
                duration: const Duration(milliseconds: 500),
                crossFadeState: frame == null
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              );
            },
          ),
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
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
