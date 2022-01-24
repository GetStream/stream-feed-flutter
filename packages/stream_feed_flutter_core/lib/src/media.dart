import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/src/attachment.dart';

/// Defines a piece of media present in a feed.
@immutable
class MediaUri extends Equatable {
  /// Creates a [MediaUri].
  const MediaUri({required this.uri, MediaType? mediaType})
      : _mediaType = mediaType;

  /// Don't use this unless you want to override mediaType and bypass
  /// our inference the file extension
  final MediaType? _mediaType;

  /// The URL for this media.
  final Uri uri;

  /// Validates a string to check if it's a URL or not.
  bool get isValidUrl => uri.hasAbsolutePath;

  /// The file extension of this media.
  ///
  /// Useful when we can't guess the MediaType (i.e. MediaType.other)
  /// and you want to act accordingly.
  String get fileExt => uri.pathSegments.last.split('.').last;

  /// Checks the [url] for specific file extensions and returns the
  /// appropriate [MediaType].
  MediaType get type {
    if (_mediaType != null) {
      return _mediaType!;
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
  List<Object?> get props => [uri, type];
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

extension MediaTypeName on MediaType {
  String get name => <MediaType, String>{
        MediaType.audio: "audio",
        MediaType.image: "image",
        MediaType.video: "video",
        MediaType.pdf: "pdf",
        MediaType.svg: "svg",
        MediaType.gif: "gif",
        MediaType.other: "other",
      }[this]!;
}

extension MediaConvertX on List<MediaUri> {
  Map<String, dynamic> toAttachments() => {
        'attachments':
            map((media) => Attachment.fromMedia(media).toJson()).toList()
      };
}
