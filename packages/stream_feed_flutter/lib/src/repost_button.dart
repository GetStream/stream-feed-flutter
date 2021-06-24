import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

class RepostButton extends StatelessWidget {
  RepostButton({this.reaction, required this.activity, this.onTap});

  ///The reaction received from stream that should be repost when pressing the RepostButton.
  final Reaction? reaction;

  ///The activity received for stream for which to show the repost button. This is used to initialize the toggle state and the counter.
  final EnrichedActivity activity;

  ///If you want to override on tap for some reasons
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ReactionToggleIcon(
      activity: activity,
      count: reaction?.childrenCounts?['repost'] ??
          activity.reactionCounts?['repost'],
      ownReactions:
          reaction?.ownChildren?['repost'] ?? activity.ownReactions?['repost'],
      activeIcon: StreamSvgIcon.repost(color: Colors.blue),
      inactiveIcon: StreamSvgIcon.repost(),
      kind: 'repost',
      onTap: onTap,
    );
  }
}
