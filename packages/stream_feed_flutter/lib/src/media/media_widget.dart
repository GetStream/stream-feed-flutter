import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

/// TODO(Groovin): Document me!
class MediaWidget extends StatefulWidget {
  /// TODO(Groovin): Document me!
  const MediaWidget({
    Key? key,
    required this.media,
  }) : super(key: key);

  /// TODO(Groovin): Document me!
  final Media media;

  @override
  _MediaWidgetState createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  late Future<String?> _getThumbnail;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    if (widget.media.mediaType == MediaType.video) {
      _getThumbnail = getTemporaryDirectory().then((result) {
        return VideoThumbnail.thumbnailFile(
          video: widget.media.url,
          thumbnailPath: result.path,
          maxWidth: mediaQuery.size.width ~/ 2,
          quality: 75,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.media.mediaType == MediaType.image) {
      return Image.network(
        widget.media.url,
        fit: BoxFit.cover,
      );
    } else if (widget.media.mediaType == MediaType.video) {
      return FutureBuilder<String?>(
        future: _getThumbnail,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          } else {
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Image.file(
                    File(snapshot.data!),
                    fit: BoxFit.cover,
                  ),
                ),
                const Icon(Icons.play_circle),
              ],
            );
          }
        },
      );
    } else {
      return Container();
    }
  }
}
