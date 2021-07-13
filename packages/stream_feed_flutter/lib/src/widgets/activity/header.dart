import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/user/user_bar.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// The Activity Header widget is a widget that displays the user's name and
/// a profile image.
class ActivityHeader extends StatelessWidget {
  const ActivityHeader({
    Key? key,
    required this.activity,
    this.onUserTap,
    this.activityKind = 'like', //TODO: enum that thing
    this.showSubtitle = true,
  });
  final EnrichedActivity activity;
  ///{@macro user_callback}
  final OnUserTap? onUserTap;
  final bool showSubtitle;

  ///Wether you want to display like activities or repost activities
  final String activityKind;
  @override
  Widget build(BuildContext context) {
    final serializedActor =
        EnrichableField.serialize(activity.actor); //TODO: ugly
    final user =
        User.fromJson(serializedActor as Map<String, dynamic>); //TODO: ugly
    return UserBar(
        user: user,
        onUserTap: onUserTap,
        timestamp: activity.time!,
        kind: activityKind,
        showSubtitle:
            showSubtitle); //TODO: display what instead of null timestamp?
  }
}
