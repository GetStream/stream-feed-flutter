import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/activity/content.dart';
import 'package:stream_feed_flutter/src/widgets/activity/footer.dart';
import 'package:stream_feed_flutter/src/widgets/activity/header.dart';

// ignore_for_file: cascade_invocations

/// {@template activity_widget}
/// A widget that displays a single activity.
/// i.e. a single post in a feed
/// {@endtemplate}
class ActivityWidget extends StatelessWidget {
  ///{@macro activity_widget}
  const ActivityWidget({
    Key? key,
    required this.activity,
    this.feedGroup = 'user',
    this.handleJsonKey = 'handle',
    this.nameJsonKey = 'name',
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

  /// The json key for the user's handle.
  final String handleJsonKey;

  /// The json key for the user's name.
  final String nameJsonKey;

  /// A callback to invoke when a mention is tapped.
  final OnMentionTap? onMentionTap;

  /// {@macro mention_callback}
  final OnHashtagTap? onHashtagTap;

  /// {@macro user_callback}
  final OnUserTap? onUserTap;

  /// {@macro activity_callback}
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          activityHeaderBuilder?.call(context, activity) ??
              ActivityHeader(
                nameJsonKey: nameJsonKey,
                handleJsonKey: handleJsonKey,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<DefaultEnrichedActivity>('activity', activity));
    properties.add(StringProperty('handleJsonKey', handleJsonKey));
    properties.add(StringProperty('nameJsonKey', nameJsonKey));
    properties.add(
        ObjectFlagProperty<OnMentionTap?>.has('onMentionTap', onMentionTap));
    properties.add(
        ObjectFlagProperty<OnHashtagTap?>.has('onHashtagTap', onHashtagTap));
    properties.add(ObjectFlagProperty<OnUserTap?>.has('onUserTap', onUserTap));
    properties.add(
        ObjectFlagProperty<OnActivityTap?>.has('onActivityTap', onActivityTap));
    properties.add(ObjectFlagProperty<ActivityFooterBuilder?>.has(
        'activityFooterBuilder', activityFooterBuilder));
    properties.add(ObjectFlagProperty<ActivityContentBuilder?>.has(
        'activityContentBuilder', activityContentBuilder));
    properties.add(ObjectFlagProperty<ActivityHeaderBuilder?>.has(
        'activityHeaderBuilder', activityHeaderBuilder));
    properties.add(StringProperty('feedGroup', feedGroup));
  }
}
