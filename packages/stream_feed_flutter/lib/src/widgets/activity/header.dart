import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/user/user_bar.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///{@template activity_header}
/// Displays the user's name and a profile image.
///{@endtemplate}
class ActivityHeader extends StatelessWidget {
  ///{@macro activity_header}
  const ActivityHeader({
    Key? key,
    required this.activity,
    this.onUserTap,
    this.activityKind = 'like', //TODO: enum that thing
    this.showSubtitle = true,
    this.handleJsonKey = 'handle',
    this.nameJsonKey = 'name',
  });
  final DefaultEnrichedActivity activity;

  ///{@macro user_callback}
  final OnUserTap? onUserTap;
  final bool showSubtitle;

  /// The json key for the user's handle.
  final String handleJsonKey;

  /// The json key for the user's name.
  final String nameJsonKey;

  /// Whether you want to display like activities or repost activities
  final String activityKind;
  @override
  Widget build(BuildContext context) {
    return UserBar(
      user: activity.actor!,
      onUserTap: onUserTap,
      timestamp: activity.time!,
      kind: activityKind,
      showSubtitle: showSubtitle,
      nameJsonKey: nameJsonKey,
      handleJsonKey: handleJsonKey,
    ); //TODO: display what instead of null timestamp?
  }
}
