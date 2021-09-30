import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/user/user_bar.dart';

/// {@template activity_header}
/// Displays the user's name and a profile image.
/// {@endtemplate}
class ActivityHeader extends StatelessWidget {
  /// Builds an [ActivityHeader].
  const ActivityHeader({
    Key? key,
    required this.activity,
    this.onUserTap,
    this.activityKind = 'like', //TODO: enum that thing
    this.showSubtitle = true,
    this.handleJsonKey = 'handle',
    this.nameJsonKey = 'name',
  }) : super(key: key);

  /// The default enriched activity ([DefaultEnrichedActivity]).
  ///
  /// The following information will be taken from the activity:
  /// - activity.actor
  /// - activity.time
  ///
  final DefaultEnrichedActivity activity;

  ///{@macro user_callback}
  final OnUserTap? onUserTap;

  /// {@macro userBar.showSubtitle}
  final bool showSubtitle;

  /// {@macro userBar.handleJsonKey}
  final String handleJsonKey;

  /// {@macro userBar.nameJsonKey}
  final String nameJsonKey;

  /// {@macro userBar.activityKind}
  final String activityKind;

  @override
  Widget build(BuildContext context) {
    return UserBar(
      user: activity.actor!, //TODO: actor will be non nullable in the future
      onUserTap: onUserTap,
      timestamp: activity.time!, //TODO: time will be non nullable in the future
      kind: activityKind,
      showSubtitle: showSubtitle,
      nameJsonKey: nameJsonKey,
      handleJsonKey: handleJsonKey,
    ); //TODO: display what instead of null timestamp?
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DefaultEnrichedActivity>('activity', activity))
      ..add(ObjectFlagProperty<OnUserTap?>.has('onUserTap', onUserTap))
      ..add(DiagnosticsProperty<bool>('showSubtitle', showSubtitle))
      ..add(StringProperty('handleJsonKey', handleJsonKey))
      ..add(StringProperty('nameJsonKey', nameJsonKey))
      ..add(StringProperty('activityKind', activityKind));
  }
}
