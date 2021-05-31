import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

class RepostButton extends StatelessWidget {
  final Reaction? reaction;
  final EnrichedActivity? activity;

  RepostButton({this.reaction, this.activity});
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
