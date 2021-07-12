import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reaction.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///The Like Button is a reaction button that displays a like icon.
/// It is used to like a post when pressed
class LikeButton extends StatelessWidget {
  LikeButton({
    Key? key,
    required this.activity,
    this.feedGroup = 'user',
    this.reaction,
    this.onTap,
    this.activeIcon,
    this.inactiveIcon,
  }) : super(key: key);

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

  final String feedGroup;

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
