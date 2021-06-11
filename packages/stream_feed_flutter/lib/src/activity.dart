import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/activity_content.dart';
import 'package:stream_feed_flutter/src/activity_header.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

class StreamFeedActivity extends StatelessWidget {
  const StreamFeedActivity(this.activity);
  final EnrichedActivity activity;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActivityHeader(activity: activity),
        ActivityContent(activity: activity),
        ActivityFooter(activity: activity)
      ],
    );
  }
}
