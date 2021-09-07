import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/media/media.dart';
import 'package:stream_feed_flutter/src/utils/tag_detector.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/media/gallery_preview.dart';
import 'package:stream_feed_flutter/src/widgets/interactive_text.dart';
import 'package:stream_feed_flutter/src/widgets/og/card.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///{@template activity_content}
/// Displays the content of an activity.
///
/// This would be the actual text of the activity, the media, etc.
///{@endtemplate}
class ActivityContent extends StatelessWidget {
  /// Builds an [ActivityContent].
  const ActivityContent({
    Key? key,
    required this.activity,
    this.onMentionTap,
    this.commentJsonKey = 'comment',
    this.onHashtagTap,
  }) : super(key: key);

  /// The activity that is being displayed.
  final DefaultEnrichedActivity activity;

  /// {@macro mention_callback}
  final OnMentionTap? onMentionTap;

  /// A callback that is invoked when the user clicks on hashtag
  final OnHashtagTap? onHashtagTap;

  /// TODO: document me
  final String commentJsonKey;

  @override
  Widget build(BuildContext context) {
    final detector = TagDetector(); //TODO: move this higher in the widget tree
    final activityObject = activity.object;
    final attachments =
        activity.extraData?['attachments']; //TODO: attachment builder
    final taggedText = activityObject != null
        ? detector.parseText(activityObject)
        : <TaggedText>[];
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          Wrap(
            //TODO: move to Text.rich(WidgetSpans)
            children: taggedText
                .map((it) => InteractiveText(
                      //TODO: not interactive in case of a response
                      tagged: it,
                      onHashtagTap: onHashtagTap,
                      onMentionTap: onMentionTap,
                    ))
                .toList(),
          ),
          //TODO: handle Video + Audio + Gallery
          GalleryPreview(
            media: [
              Media(
                url:
                    'https://i.picsum.photos/id/785/200/200.jpg?hmac=vvHnS4TgoGTRqwI2soaIhbOxE7Q-hhoZTTDe75h_fz4',
              ),
              Media(
                url:
                    'https://i.picsum.photos/id/665/200/200.jpg?hmac=hWcfvzYgHAwJFOUaHZa2oZpOOL7yx_x8Bnhq0dFVQRw',
              ),
              Media(
                url:
                    'https://i.picsum.photos/id/247/200/200.jpg?hmac=oKt3N5MCdI8hCrzIbokjpVNzUuywbK64CJn1bfRAxbA',
              ),
              Media(
                url:
                    'https://i.picsum.photos/id/533/200/200.jpg?hmac=HvhCl1BSaQrsbedBJm-X8gfnZGp_222QGZ-mYnstPiA',
              ),
              Media(
                url:
                    'https://i.picsum.photos/id/715/200/200.jpg?hmac=eR-80S6YYIV9vV26EYLSVACDM5HWe94Oz2hx0icP5vI',
              ),
              Media(
                url:
                    'https://i.picsum.photos/id/197/200/200.jpg?hmac=QpHQ9OiY_-qagHPzHZgTw7I_nE3LevYjH_1k3-xLpPk',
              ),
            ],
          ),
          if (attachments != null)
            ActivityCard(
              og: OpenGraphData.fromJson(attachments as Map<String, dynamic>),
            )
        ],
      ),
    );
  }
}
