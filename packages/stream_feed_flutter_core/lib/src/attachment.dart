import 'package:stream_feed_flutter_core/src/media.dart';

class Attachment {
  final String url;
  final String mediatype;
  Attachment({required this.url, required this.mediatype});
  Attachment.fromMedia(MediaUri mediaUri)
      : url = mediaUri.uri.toString(),
        mediatype = mediaUri.type.name;

  Map<String, dynamic> toJson() => {'url': url, 'type': mediatype};
}
