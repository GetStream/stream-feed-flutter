import 'package:equatable/equatable.dart';
import 'package:stream_feed_flutter_core/src/media.dart';

/// An [Attachment] model to convert a [MediaUri] TO a [Map]
/// to send as an
/// [extraData] along an activity or a reaction. For example:
/// ```dart
/// final bloc = FeedProvider.of(context).bloc;
/// final uploadController = bloc.uploadController;
/// final extraData = uploadController.getMediaUris()?.toExtraData();
/// await bloc.onAddReaction( kind: 'comment', data: extraData,
/// activity: parentActivity, feedGroup: feedGroup );
/// ```
/// The attachment model is also useful to convert FROM extraData in an activity
/// or reaction via the `toAttachments` extension. For example:
/// ```dart
/// final attachments = activity.extraData?.toAttachments()
/// ```
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
  /// An extension to get the [MediaType] from a [String]
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
