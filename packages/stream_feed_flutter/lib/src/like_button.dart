import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/icons.dart';
import 'package:stream_feed_flutter/src/reaction_button.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class LikeButton extends StatelessWidget {
  LikeButton({
    this.reaction,
    required this.activity,
    this.onTap,
    this.activeIcon,
    this.inactiveIcon,
  });

  ///The reaction received from stream that should be liked when pressing the LikeButton.
  final Reaction? reaction;

  /// The activity received from stream that should be liked when pressing the LikeButton.
  final EnrichedActivity activity;

  ///If you want to override on tap for some reasons
  final VoidCallback? onTap;

  ///If you want to override the activeIcon
  final Widget? activeIcon;

  ///If you want to override the inactiveIcon
  final Widget? inactiveIcon;

  @override
  Widget build(BuildContext context) {
    return ReactionButton(
      activity: activity,
      activeIcon: activeIcon ?? StreamSvgIcon.loveActive(),
      inactiveIcon: inactiveIcon ?? StreamSvgIcon.loveInactive(),
      hoverColor: Colors.red.shade100,

      ///TODO: third state hover on desktop
      reaction: reaction,
      kind: 'like',
      onTap: onTap,
    );
  }
}
