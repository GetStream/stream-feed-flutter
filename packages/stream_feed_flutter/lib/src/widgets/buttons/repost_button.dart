import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reaction_button.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class RepostButton extends StatelessWidget {
  RepostButton({
    this.reaction,
    required this.activity,
    this.onTap,
    this.inactiveIcon,
    this.activeIcon,
  });

  ///If you want to override the activeIcon
  final Widget? activeIcon;

  ///If you want to override the inactiveIcon
  final Widget? inactiveIcon;

  ///The reaction received from stream that should be liked when pressing the LikeButton.
  final Reaction? reaction;

  /// The activity received from stream that should be liked when pressing the LikeButton.
  final EnrichedActivity activity;

  ///If you want to override on tap for some reasons
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ReactionButton(
      activity: activity,
      reaction: reaction,
      activeIcon: activeIcon ?? StreamSvgIcon.repost(color: Colors.blue),
      inactiveIcon: inactiveIcon ?? StreamSvgIcon.repost(color: Colors.grey),
      hoverColor: Colors.green.shade100,
      kind: 'repost',
      onTap: onTap,
    );
  }
}
