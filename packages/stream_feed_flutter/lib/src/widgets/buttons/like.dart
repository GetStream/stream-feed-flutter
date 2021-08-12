import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reaction.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///{@template like_button}
/// A reaction button that displays a like icon.
///
/// It is used to like a post when pressed.
///{@endtemplate}
class LikeButton extends StatelessWidget {
  /// Builds a [LikeButton].
  const LikeButton({
    Key? key,
    required this.activity,
    this.feedGroup = 'user',
    this.reaction,
    this.onTap,
    this.activeIcon,
    this.inactiveIcon,
  }) : super(key: key);

  /// The reaction received from Stream that should be liked when pressing
  /// the [LikeButton].
  final Reaction? reaction;

  /// The activity received from Stream that should be liked when pressing
  /// the [LikeButton].
  final EnrichedActivity activity;

  /// The callback to be performed on tap.
  ///
  /// This is generally not to be overridden, but can be done if developers
  /// wish.
  final VoidCallback? onTap;

  /// The icon to display when a post has been liked by the current user.
  final Widget? activeIcon;

  /// The icon to display when a post has not yet been liked by the current
  /// user.
  final Widget? inactiveIcon;

  /// The feed group that this [LikeButton] is associated with.
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
