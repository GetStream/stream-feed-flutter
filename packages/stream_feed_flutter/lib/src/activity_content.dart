import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/typedefs.dart';
import 'package:stream_feed_flutter/src/utils/tag_detector.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'utils/extensions.dart';

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
    final taggedText = activityObject != null
        ? detector.parseText(activityObject as String)
        : <TaggedText?>[];
    return Column(
      children: [
        Wrap(
          //TODO: move to Text.rich(WidgetSpans)
          children: taggedText
              .map((it) => _InteractiveText(
                    tagged: it,
                    onHashtagTap: onHashtagTap,
                    onMentionTap: onMentionTap,
                  ))
              .toList(),
        )
        //TODO: handle Card + Video + Audio + Gallery
      ],
    );
  }
}

class _InteractiveText extends StatelessWidget {
  final OnMentionTap? onMentionTap;
  final OnHashtagTap? onHashtagTap;
  final TaggedText? tagged;
  const _InteractiveText({
    this.tagged,
    this.onHashtagTap,
    this.onMentionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tagged != null) {
      switch (tagged!.tag) {
        case Tag.normalText:
          return Text('${tagged!.text!} ', style: tagged!.tag.style());
        case Tag.hashtag:
          return InkWell(
            onTap: () {
              onHashtagTap?.call(tagged!.text?.trim().replaceFirst('#', ''));
            },
            child: Text(tagged!.text!, style: tagged!.tag.style()),
          );
        case Tag.mention:
          return InkWell(
            onTap: () {
              onMentionTap?.call(tagged!.text?.trim().replaceFirst('@', ''));
            },
            child: Text(tagged!.text!, style: tagged!.tag.style()),
          );
        default:
          return Text(tagged!.text!, style: tagged!.tag.style());
      }
    } else {
      return Offstage();
    }
  }
}
