import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/activity_content.dart';
import 'package:stream_feed_flutter/src/activity_header.dart';
import 'package:stream_feed_flutter/src/typedefs.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

class StreamFeedActivity extends StatelessWidget {
  const StreamFeedActivity(
      {required this.activity,
      this.onHashtagTap,
      this.onMentionTap,
      this.onUserTap});
  final EnrichedActivity activity;
  final OnMentionTap? onMentionTap;
  final OnHashtagTap? onHashtagTap;
  final OnUserTap? onUserTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActivityHeader(
          //TODO: builders
          activity: activity,
          onUserTap: onUserTap,
        ),
        Expanded(
          child: ActivityContent(
            //TODO: builders
            activity: activity,
            onHashtagTap: onHashtagTap,
            onMentionTap: onMentionTap,
          ),
        ),
        ActivityFooter(
            //TODO: builders
            activity: activity)
      ],
    );
  }
}
