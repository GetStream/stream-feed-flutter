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
      this.onUserTap,
      this.activityFooterBuilder,
      this.onActivityTap});
  final EnrichedActivity activity;
  final OnMentionTap? onMentionTap;
  final OnHashtagTap? onHashtagTap;
  final OnUserTap? onUserTap;
  final OnActivityTap? onActivityTap;
  final ActivityFooterBuilder? activityFooterBuilder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onActivityTap?.call(context,activity);
      },
      child: Column(
        children: [
          ActivityHeader(
            //TODO: builders
            activity: activity,
            onUserTap: onUserTap,
          ),
          ActivityContent(
            //TODO: builders
            activity: activity,
            onHashtagTap: onHashtagTap,
            onMentionTap: onMentionTap,
          ),
          activityFooterBuilder?.call(context, activity) ??
              ActivityFooter(activity: activity)
        ],
      ),
    );
  }
}
