import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/user/user_bar.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// {@template activity_header}
/// Displays the user's name and a profile image.
/// {@endtemplate}
class ActivityHeader extends StatelessWidget {
  /// Builds an [ActivityHeader].
  const ActivityHeader({
    Key? key,
    required this.activity,
    required this.feedGroup,
    this.onUserTap,
    this.activityKind = 'like', //TODO: enum that thing
    this.showSubtitle = true,
    this.handleJsonKey = 'handle',
    this.nameJsonKey = 'name',
  }) : super(key: key);

  final EnrichedActivity activity;

  ///{@macro user_callback}
  final OnUserTap? onUserTap;

  final bool showSubtitle;

  /// The json key for the user's handle.
  final String handleJsonKey;

  /// The json key for the user's name.
  final String nameJsonKey;

  /// Whether you want to display like activities or repost activities
  final String activityKind;

  /// The feed group that the activity belongs to.
  ///
  /// Ex: 'timeline'.
  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    return UserBar(
      activityId: activity.id!,
      feedGroup: feedGroup,
      user: activity.actor!, //TODO: actor will be non nullable in the future
      onUserTap: onUserTap,
      timestamp: activity.time!, //TODO: time will be non nullable in the future
      kind: activityKind,
      showSubtitle: showSubtitle,
      nameJsonKey: nameJsonKey,
      handleJsonKey: handleJsonKey,
      subtitle: Text(activity.actor!.data![handleJsonKey].toString()),
    ); //TODO: display what instead of null timestamp?
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EnrichedActivity>('activity', activity));
    properties.add(ObjectFlagProperty<OnUserTap?>.has('onUserTap', onUserTap));
    properties.add(DiagnosticsProperty<bool>('showSubtitle', showSubtitle));
    properties.add(StringProperty('handleJsonKey', handleJsonKey));
    properties.add(StringProperty('nameJsonKey', nameJsonKey));
    properties.add(StringProperty('activityKind', activityKind));
    properties.add(StringProperty('feedGroup', feedGroup));
  }
}
