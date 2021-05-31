import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

class LikeButton extends StatelessWidget {
  final Reaction? reaction;
  final EnrichedActivity? activity;

  LikeButton({this.reaction, this.activity});
  @override
  Widget build(BuildContext context) {
    return ReactionToggleIcon(
      count: reaction?.childrenCounts?['like'] ??
          activity?.reactionCounts?['like'],
      ownReactions:
          reaction?.ownChildren?['like'] ?? activity?.ownReactions?['like'],
      activeIcon: StreamSvgIcon.loveActive(),
      inactiveIcon: StreamSvgIcon.loveInactive(),
      kind: 'like',
    );
  }
}
