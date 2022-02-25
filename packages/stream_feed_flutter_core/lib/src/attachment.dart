import 'package:equatable/equatable.dart';
import 'package:stream_feed_flutter_core/src/media.dart';

/// An attachment model to convert (via [toAttachments] extension)
/// from a [MediaUri] object you get from the [UploadController]
/// OR to convert (via [toExtraData]) to a Map<String, Object?> to send as an
/// extraData along an activity or a reaction
class Attachment extends Equatable {
  const Attachment({
    required this.url,
    required this.mediaType,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        url: json['url'],
        mediaType: (json['type'] as String).mediaType,
      );

  Attachment.fromMedia(MediaUri mediaUri)
      : url = mediaUri.uri.toString(),
        mediaType = mediaUri.type;

  final String url;

  final MediaType mediaType;

  //TODO(sacha): Attachment.fromOg
  Map<String, dynamic> toJson() => {
        'url': url,
        'type': mediaType.name,
      };

  @override
  List<Object?> get props => [url, mediaType];
}

extension MediaTypeString on String {
  MediaType get mediaType => <String, MediaType>{
        'audio': MediaType.audio,
        'image': MediaType.image,
        'video': MediaType.video,
        'pdf': MediaType.pdf,
        'svg': MediaType.svg,
        'gif': MediaType.gif,
        'other': MediaType.other,
      }[this]!;
}
