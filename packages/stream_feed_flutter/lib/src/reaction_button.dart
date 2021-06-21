import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ReactionButton extends StatelessWidget {
  ReactionButton({
    required this.activity,
    required this.kind,
    required this.activeIcon,
    required this.inactiveIcon,
    this.hoverColor = Colors.lightBlue,
    this.reaction,
    this.onTap,
    this.data,
  });

  ///The reaction received from stream that should be liked when pressing the LikeButton.
  final Reaction? reaction;

  /// The activity received from stream that should be liked when pressing the LikeButton.
  final EnrichedActivity activity;

  ///If you want to override on tap for some reasons
  final VoidCallback? onTap;

  final String kind;

  /// The button to display if the user already reacted
  final Widget activeIcon;

  /// The button to display if the user didn't reacted yet
  final Widget inactiveIcon;

  final Map<String, Object>? data;

  final Color hoverColor;

  @override
  Widget build(BuildContext context) {
    return ReactionToggleIcon(
      activity: activity,
      count: reaction?.childrenCounts?[kind] ?? activity.reactionCounts?[kind],
      ownReactions:
          reaction?.ownChildren?[kind] ?? activity.ownReactions?[kind],
      activeIcon: activeIcon,
      inactiveIcon: inactiveIcon,
      hoverColor: hoverColor,
      kind: kind,
      onTap: onTap,
      data: data,
    );
  }
}
