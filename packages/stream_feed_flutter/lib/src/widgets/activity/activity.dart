import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/activity/content.dart';
import 'package:stream_feed_flutter/src/widgets/activity/footer.dart';
import 'package:stream_feed_flutter/src/widgets/activity/header.dart';

///{@template activity_widget}
/// A widget that displays a single activity.
/// i.e. a single post in a feed
///{@endtemplate}
class ActivityWidget extends StatelessWidget {
  ///{@macro activity_widget}
  const ActivityWidget({
    Key? key,
    required this.activity,
    this.feedGroup = 'user',
    this.onHashtagTap,
    this.onMentionTap,
    this.onUserTap,
    this.activityFooterBuilder,
    this.activityContentBuilder,
    this.activityHeaderBuilder,
    this.onActivityTap,
  }) : super(key: key);

  /// The activity to display.
  final DefaultEnrichedActivity activity;

  /// A callback to invoke when a mention is tapped.
  final OnMentionTap? onMentionTap;

  ///{@macro mention_callback}
  final OnHashtagTap? onHashtagTap;

  ///{@macro user_callback}
  final OnUserTap? onUserTap;

  ///{@macro activity_callback}
  final OnActivityTap? onActivityTap;

  /// A builder for the activity footer.
  final ActivityFooterBuilder? activityFooterBuilder;

  /// A builder for the activity content.
  final ActivityContentBuilder? activityContentBuilder;

  /// A builder for the activity header.
  final ActivityHeaderBuilder? activityHeaderBuilder;

  /// The group of the feed this activity belongs to.
  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onActivityTap?.call(context, activity);
      },
      child: Column(
        children: [
          activityHeaderBuilder?.call(context, activity) ??
              ActivityHeader(
                activity: activity,
                onUserTap: onUserTap,
              ),
          activityContentBuilder?.call(context, activity) ??
              ActivityContent(
                activity: activity,
                onHashtagTap: onHashtagTap,
                onMentionTap: onMentionTap,
              ),
          activityFooterBuilder?.call(context, activity) ??
              ActivityFooter(
                activity: activity,
                feedGroup: feedGroup,
              )
        ],
      ),
    );
  }
}
