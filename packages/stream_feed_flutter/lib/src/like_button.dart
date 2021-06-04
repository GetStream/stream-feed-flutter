import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

class LikeButton extends StatelessWidget {
  LikeButton({this.reaction, this.activity});

  ///The reaction received from stream that should be liked when pressing the LikeButton.
  final Reaction? reaction;

  /// The activity received from stream that should be liked when pressing the LikeButton.
  final EnrichedActivity? activity;

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
