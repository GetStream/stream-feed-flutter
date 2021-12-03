
import 'package:equatable/equatable.dart';

/// Defines a piece of media present in a feed.
class Media extends Equatable{
  /// Builds a [Media].
  Media({
    required this.url,
  });

  /// The URL for this media.
  final String url;

  /// Validates a string to check if it's a url or not
  bool get isValidUrl => Uri.tryParse(url)?.hasAbsolutePath ?? false;

  /// Checks the [url] for specific file extensions and returns the
  /// appropriate [MediaType].
  MediaType get mediaType {
    final fileExt = Uri.parse(url).pathSegments.last.split('.').last;

    if (fileExt == 'jpeg') {
      return MediaType.image;
    } else if (fileExt == 'jpg') {
      return MediaType.image;
    } else if (fileExt == 'png') {
      return MediaType.image;
    } else if (fileExt == 'mp3') {
      return MediaType.audio;
    } else if (fileExt == 'wav') {
      return MediaType.audio;
    } else if (fileExt == 'mp4') {
      return MediaType.video;
    } else {
      return MediaType.unknown;
    }
  }

  @override
  List<Object?> get props => [url];
}

/// Enumerates the types of supported media in Feeds.
enum MediaType {
  /// Audio media
  audio,

  /// Image media
  image,

  /// Video media
  video,

  /// Unknown or unsupported media type
  unknown
}
