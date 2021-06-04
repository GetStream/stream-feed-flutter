import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

class RepostButton extends StatelessWidget {
  RepostButton({this.reaction, this.activity});

  ///The reaction received from stream that should be repost when pressing the RepostButton.
  final Reaction? reaction;

  ///The activity received for stream for which to show the repost button. This is used to initialize the toggle state and the counter.
  final EnrichedActivity? activity;

  @override
  Widget build(BuildContext context) {
    return ReactionToggleIcon(
      count: reaction?.childrenCounts?['repost'] ??
          activity?.reactionCounts?['repost'],
      ownReactions:
          reaction?.ownChildren?['repost'] ?? activity?.ownReactions?['like'],
      activeIcon: StreamSvgIcon.repost(color: Colors.blue),
      inactiveIcon: StreamSvgIcon.repost(),
      kind: 'repost',
    );
  }
}
