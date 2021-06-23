import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class FlatFeed extends StatelessWidget {
  //TODO: put this in core with a builder List<EnrichedActivity>
  const FlatFeed({
    Key? key,
    required this.feedGroup,
    this.onHashtagTap,
    this.onMentionTap,
    this.onUserTap,
    this.activityFooterBuilder,
  }) : super(key: key);

  final OnHashtagTap? onHashtagTap;
  final OnMentionTap? onMentionTap;
  final OnUserTap? onUserTap;
  final String feedGroup;
  final ActivityFooterBuilder? activityFooterBuilder;

  @override
  Widget build(BuildContext context) {
    return FlatFeedCore(
      onSuccess: (BuildContext context, List<EnrichedActivity> activities) {
        return FlatFeedInner(
          feedGroup: feedGroup,
          activities: activities, //TODO: no activity to display widget
          onHashtagTap: onHashtagTap,
          onMentionTap: onMentionTap,
          onUserTap: onUserTap,
          activityFooterBuilder: activityFooterBuilder,
        );
      },
      feedGroup: 'user',
    );
  }
}

class FlatFeedInner extends StatelessWidget {
  const FlatFeedInner({
    Key? key,
    required this.activities,
    this.onHashtagTap,
    this.onMentionTap,
    this.onUserTap,
    this.activityFooterBuilder,
    this.feedGroup = 'user',
  }) : super(key: key);

  final OnHashtagTap? onHashtagTap;
  final OnMentionTap? onMentionTap;
  final OnUserTap? onUserTap;
  final List<EnrichedActivity> activities;
  final ActivityFooterBuilder? activityFooterBuilder;

  ///The feed group part of the feed
  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, idx) => StreamFeedActivity(
        activity: activities[idx],
        feedGroup: feedGroup,
        onHashtagTap: onHashtagTap,
        onMentionTap: onMentionTap,
        onUserTap: onUserTap,
        //TODO: onActivityTap:onActivityTap,
        activityFooterBuilder: activityFooterBuilder,
      ),
    );
  }
}
