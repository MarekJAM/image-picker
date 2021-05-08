import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
        DownloadButton(photo: photo),
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class DownloadButton extends StatefulWidget {
  const DownloadButton({
    Key key,
    @required this.photo,
  }) : super(key: key);

  final Photo photo;

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  static const debug = true;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }

    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5,
      left: 5,
      child: IconButton(
        icon: Icon(
          Icons.download_sharp,
          size: 30,
        ),
        onPressed: () async {
          final path =
              await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);

          if (await Permission.storage.request().isGranted) {
            final taskId = await FlutterDownloader.enqueue(
              url: widget.photo.downloadUrl,
              savedDir: path,
              showNotification: true,
              openFileFromNotification: true,
            );
          }
        },
      ),
    );
  }
}
