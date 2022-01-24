import 'package:equatable/equatable.dart';
import 'package:stream_feed_flutter_core/src/media.dart';

class Attachment extends Equatable {
  const Attachment({
    required this.url,
    required this.mediatype,
  });

  final String url;
  final MediaType mediatype;

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        url: json["url"],
        mediatype: (json["type"] as String).mediaType,
      );

  Attachment.fromMedia(MediaUri mediaUri)
      : url = mediaUri.uri.toString(),
        mediatype = mediaUri.type;

        //TODO(sacha): Attachment.fromOg
  Map<String, dynamic> toJson() => {
        "url": url,
        "type": mediatype.name,
      };

  @override
  List<Object?> get props => [url, mediatype];
}

extension MediaTypeString on String {
  MediaType get mediaType => <String, MediaType>{
        "audio": MediaType.audio,
        "image": MediaType.image,
        "video": MediaType.video,
        "pdf": MediaType.pdf,
        "svg": MediaType.svg,
        "gif": MediaType.gif,
        "other": MediaType.other,
      }[this]!;
}
