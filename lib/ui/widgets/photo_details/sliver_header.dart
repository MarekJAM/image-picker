import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import '../../../data/models/models.dart';
import '../../../bloc/blocs.dart';

class SliverHeader extends SliverPersistentHeaderDelegate {
  final Photo photo;
  final bool isFavorite;
  final double minExtent;
  final double maxExtent;

  SliverHeader({
    @required this.photo,
    @required this.isFavorite,
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
                crossFadeState:
                    frame == null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              );
            },
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border_outlined,
              size: 30,
            ),
            onPressed: () {
              isFavorite
                  ? BlocProvider.of<FavoritePhotosBloc>(context)
                      .add(RemovePhotoFromFavorites(id: photo.id))
                  : BlocProvider.of<FavoritePhotosBloc>(context)
                      .add(AddPhotoToFavorites(photo: photo));
            },
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
