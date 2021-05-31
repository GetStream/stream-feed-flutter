import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

class LikeButton extends StatelessWidget {
  final Reaction reaction;

  LikeButton({required this.reaction});
  @override
  Widget build(BuildContext context) {
    return ReactionToggleIcon(
      count: reaction.childrenCounts?['like'],
      ownReactions: reaction.ownChildren?['like'],
      activeIcon: StreamSvgIcon.loveActive(),
      inactiveIcon: StreamSvgIcon.loveInactive(),
      kind: 'like',
    );
  }
}
