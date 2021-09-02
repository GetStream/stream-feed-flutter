import 'package:stream_feed_flutter/src/media/media_types.dart';

/// Defines a piece of media present in a feed.
class Media {
  /// Builds a [Media].
  Media({
    required this.url,
  });

  /// The URL for this media.
  final String url;

  /// Checks the [url] for specific file extensions and returns the
  /// appropriate [MediaType].
  MediaType get mediaType {
    if (url.contains('jpeg')) {
      return MediaType.image;
    } else if (url.contains('jpg')) {
      return MediaType.image;
    } else if (url.contains('png')) {
      return MediaType.image;
    } else if (url.contains('mp3')) {
      return MediaType.audio;
    } else if (url.contains('wav')) {
      return MediaType.audio;
    } else if (url.contains('mp4')) {
      return MediaType.video;
    } else {
      return MediaType.unknown;
    }
  }
}
