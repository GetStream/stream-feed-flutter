import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/og/card.dart';
import 'package:stream_feed_flutter/src/widgets/interactive_text.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/utils/tag_detector.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///{@template activity_content}
/// Displays the content of an activity.
///
/// This would be the actual text of the activity, the media, etc.
///{@endtemplate}
class ActivityContent extends StatelessWidget {
  ///The activity that is being displayed.
  final EnrichedActivity activity;

  ///{@macro mention_callback}
  final OnMentionTap? onMentionTap;

  /// A callback that is invoked when the user clicks on hashtag
  final OnHashtagTap? onHashtagTap;
  final String commentJsonKey;

  ///{@macro activity_content}
  const ActivityContent({
    Key? key,
    required this.activity,
    this.onMentionTap,
    this.commentJsonKey = 'comment',
    this.onHashtagTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detector = TagDetector(); //TODO: move this higher in the widget tree
    final activityObject = activity.object;
    final attachments =
        activity.extraData?['attachments']; //TODO: attachment builder
    final taggedText = activityObject != null
        ? detector.parseText(
            EnrichableField.serialize(activityObject) as String) //TODO: ugly
        : <TaggedText>[];
    return Column(
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
        if (attachments != null)
          ActivityCard(
              og: OpenGraphData.fromJson(attachments as Map<String, dynamic>))
      ],
    );
  }
}
