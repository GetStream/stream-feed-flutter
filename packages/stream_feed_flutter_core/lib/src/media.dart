import 'package:equatable/equatable.dart';

/// Defines a piece of media present in a feed.
class MediaUri extends Equatable {
  /// Builds a [Media].
  const MediaUri({required this.uri, this.mediaType});

  ///Don't use this unless you want to override mediaType
  final MediaType? mediaType;

  /// The URL for this media.
  final Uri uri;

  /// Validates a string to check if it's a url or not
  bool get isValidUrl => uri.hasAbsolutePath;

  /// The file extension of this media
  /// Useful when we can't guess the MediaType (i.e. MediaType.other)
  /// and you want to act accordingly
  String get fileExt => uri.pathSegments.last.split('.').last;

  /// Checks the [url] for specific file extensions and returns the
  /// appropriate [MediaType].
  MediaType get type {
    if (mediaType != null) {
      return mediaType!;
    } else {
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
      } else if (fileExt == 'pdf') {
        return MediaType.pdf;
      } else if (fileExt == 'svg') {
        return MediaType.svg;
      } else if (fileExt == 'gif') {
        return MediaType.gif;
      } else {
        return MediaType.other;
      }
    }
  }

  @override
  List<Object?> get props => [uri];
}

/// Enumerates the types of supported media in Feeds.
enum MediaType {
  /// Audio media
  audio,

  /// Image media
  image,

  /// Video media
  video,

  /// Pdf
  pdf,

  /// Svg
  svg,

  /// Gif
  gif,

  /// Unknown or unsupported media type
  other,
}
