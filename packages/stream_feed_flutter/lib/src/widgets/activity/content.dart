import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/og/card.dart';
import 'package:stream_feed_flutter/src/widgets/interactive_text.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/utils/tag_detector.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ActivityContent extends StatelessWidget {
  final EnrichedActivity activity;
  final OnMentionTap? onMentionTap;
  final OnHashtagTap? onHashtagTap;

  const ActivityContent({
    required this.activity,
    this.onMentionTap,
    this.onHashtagTap,
  });

  @override
  Widget build(BuildContext context) {
    final detector = TagDetector(); //TODO: move this higher in the widget tree
    final activityObject = activity.object;
    final attachments = activity.extraData?['attachments'];
    final taggedText = activityObject != null
        ? detector.parseText(
            EnrichableField.serialize(activityObject) as String) //TODO: ugly
        : <TaggedText?>[];
    return Expanded(
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
          if (attachments != null)
            StreamFeedCard(
                og: OpenGraphData.fromJson(attachments as Map<String, dynamic>))
        ],
      ),
    );
  }
}
