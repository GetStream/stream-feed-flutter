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

  // final OpenGraphData? og;

  const ActivityContent({
    required this.activity,
    this.onMentionTap,
    this.onHashtagTap,
    // this.og, //
  });

  @override
  Widget build(BuildContext context) {
    final ogRaw = activity.extraData!['attachments']
        as Map<String, dynamic>; //TODO: handle case null
    final og = OpenGraphData.fromJson(ogRaw);
    print(og);
    final detector = TagDetector(); //TODO: move this higher in the widget tree
    final activityObject = activity.object;
    final taggedText = activityObject != null
        ? detector.parseText(
            EnrichableField.serialize(activityObject) as String) //TODO: ugly
        : <TaggedText?>[];
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
        StreamFeedCard(og: og)
      ],
    );
  }
}
