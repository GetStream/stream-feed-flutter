import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

/// {@template mediaWidget}
/// Displays various kinds of [Media].
///
/// If the [attachment] is a video, it will display a thumbnail.
/// {@endtemplate}
class MediaWidget extends StatefulWidget {
  /// {@macro mediaWidget}
  const MediaWidget({
    Key? key,
    required this.attachment,
  }) : super(key: key);

  /// The media to display.
  final Attachment attachment;

  @override
  _MediaWidgetState createState() => _MediaWidgetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Attachment>('attachment', attachment));
  }
}

class _MediaWidgetState extends State<MediaWidget> {
  late Future<String?> _getThumbnail;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    if (widget.attachment.runtimeType == MediaType.video) {
      _getThumbnail = getTemporaryDirectory().then((result) {
        return VideoThumbnail.thumbnailFile(
          video: widget.attachment.url,
          thumbnailPath: result.path,
          maxWidth: mediaQuery.size.width ~/ 2,
          quality: 75,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.attachment.mediaType == MediaType.image) {
      return Image.network(
        widget.attachment.url,
        fit: BoxFit.cover,
      );
    } else if (widget.attachment.mediaType == MediaType.video) {
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
      return const SizedBox.shrink();
    }
  }
}
