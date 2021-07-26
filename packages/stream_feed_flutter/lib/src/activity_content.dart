import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/card.dart';
import 'package:stream_feed_flutter/src/interactive_text.dart';
import 'package:stream_feed_flutter/src/typedefs.dart';
import 'package:stream_feed_flutter/src/utils/tag_detector.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ActivityContent extends StatelessWidget {
  final EnrichedActivity activity;
  final OnMentionTap? onMentionTap;
  final OnHashtagTap? onHashtagTap;
  final String commentJsonKey;
  final OpenGraphData? og;

  const ActivityContent(
      {required this.activity,
      this.onMentionTap,
      this.onHashtagTap,
      this.og, //attachments
      this.commentJsonKey = 'text'});

  @override
  Widget build(BuildContext context) {
    final detector = TagDetector(); //TODO: move this higher in the widget tree
    final activityObject = activity.object;
    final taggedText = activityObject != null
        ? detector.parseText((EnrichableField.serialize(activityObject)
            as Map<String, Object?>)[commentJsonKey] as String) //TODO: ugly
        : <TaggedText>[];
    return Column(
      children: [
        Wrap(
          //TODO: move to Text.rich(WidgetSpans)
          children: taggedText
              .map((it) => InteractiveText(
                    tagged: it,
                    onHashtagTap: onHashtagTap,
                    onMentionTap: onMentionTap,
                  ))
              .toList(),
        ),
        //TODO: handle Video + Audio + Gallery
        if (og != null) StreamFeedCard(og: og!)
      ],
    );
  }
}
